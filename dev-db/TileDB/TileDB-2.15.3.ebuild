# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="The Universal Storage Engine"
HOMEPAGE="https://tiledb.com/"

EGIT_REPO_URI="https://github.com/TileDB-Inc/TileDB.git"
EGIT_BRANCH=release-2.15
EGIT_COMMIT="689bea02c3ab28a908d79ebfd1d744f0e5ea5415"

PATCHES=(
	"${FILESDIR}/TileDB-2.15.3-cancel-magic-download.patch"
	"${FILESDIR}/TileDB-2.10.2-cancel-capnp-download.patch"
	"${FILESDIR}/TileDB-2.13.0-cancel-catch-download.patch"
	"${FILESDIR}/TileDB-2.15.3-cancel-webp-download.patch"
)

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~x86"
IUSE="debug doc +s3 +serialization +webp"
CATCH2_REV="v3.1.0"
MAGIC_REV="5.38.1.tiledb"
CAPNPROTO_REV="v0.8.0"
WEBP_COMMIT="a19a25bb03757d5bb14f8d9755ab39f06d0ae5ef"
WEBP_BRANCH="v1.3.0"
CMAKE_MAKEFILE_GENERATOR=emake


BDEPEND="doc? ( dev-python/sphinx 
	        dev-python/sphinx_rtd_theme
		dev-python/sphinxcontrib-contentui
		dev-python/breathe )
	 >=dev-util/cmake-3.21"

DEPEND="dev-libs/spdlog
	dev-libs/libfmt
	sys-libs/zlib
	app-doc/doxygen
	app-arch/lz4
	s3? ( dev-libs/aws-sdk-cpp[access-management,s3] )
	dev-cpp/clipp
	"

src_unpack()
{
	git-r3_fetch "https://github.com/catchorg/Catch2.git" ${CATCH2_REV}
	git-r3_fetch "https://github.com/TileDB-Inc/file-windows.git" ${MAGIC_REV}
	git-r3_fetch "https://chromium.googlesource.com/webm/libwebp" ${WEBP_BRANCH}
	if use serialization; then git-r3_fetch "https://github.com/capnproto/capnproto.git" ${CAPNPROTO_REV}; fi
	git-r3_src_unpack
	git-r3_checkout "https://github.com/TileDB-Inc/file-windows.git" ep_magic
	git-r3_checkout "https://github.com/catchorg/Catch2.git" ep_catch
	if use webp; then git-r3_checkout "https://chromium.googlesource.com/webm/libwebp" ep_webp; fi
	if use serialization; then git-r3_checkout "https://github.com/capnproto/capnproto.git" ep_capnp; fi
	mkdir -p "${BUILD_DIR}/externals/src"
	mv ${WORKDIR}/ep_magic "${BUILD_DIR}/externals/src"
	mv ${WORKDIR}/ep_catch "${BUILD_DIR}/externals/src"
	if use serialization; then mv ${WORKDIR}/ep_capnp "${BUILD_DIR}/externals/src"; fi
	if use webp; then mv ${WORKDIR}/ep_webp "${BUILD_DIR}/externals/src"; fi
}

src_prepare() {
	edos2unix ${S}/cmake/Modules/FindWebp_EP.cmake
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_C_FLAGS=-DSPDLOG_FMT_EXTERNAL
		-DCMAKE_CXX_FLAGS=-DSPDLOG_FMT_EXTERNAL
		-DTILEDB_TOOLS=TRUE
	)
	if use s3 ; then
		mycmakeargs+=( -DTILEDB_S3=TRUE )		
	fi
	if use serialization ; then
		mycmakeargs+=( -DTILEDB_SERIALIZATION=TRUE )
		mycmakeargs+=( -DTILEDB_CAPNPROTO_SRC=${BUILD_DIR}/externals/src/ep_capnp )
		mycmakeargs+=( -DTILEDB_WEBP_SRC=${BUILD_DIR}/externals/src/ep_webp )
	fi
	if use webp ; then
		mycmakeargs+=( -DTILEDB_WEBP=TRUE )
	else
		mycmakeargs+=( -DTILEDB_WEBP=FALSE )
	fi
	if use debug ; then
		mycmakeargs+=(-DCMAKE_BUILD_TYPE=Debug
			      -DCMAKE_C_FLAGS=-O0\ -ggdb
			      -DCMAKE_CXX_FLAGS=-O0\ -ggdb)
	fi
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
#	cd ${BUILD_DIR} && make doc
#	use doc && cd ${S}/tiledb/doxygen && TILEDB_DIR="${S}" DOX_XML_DIR="${BUILD_DIR}"/xml sphinx-build -E -T -b html -d doctrees -D language=en source html
}

src_install() {
	cd ${BUILD_DIR} && DESTDIR="${D}" ${CMAKE_MAKEFILE_GENERATOR} install-tiledb
	#if `use doc`
	#then dodoc -r ${S}/tiledb/doxygen/html
	#fi
	#einstalldocs
	rm -fR "${ED}"/usr/$(get_libdir)/libwebp*
}

