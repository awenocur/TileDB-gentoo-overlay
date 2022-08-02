# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="The Universal Storage Engine"
HOMEPAGE="https://tiledb.com/"

EGIT_REPO_URI="https://github.com/TileDB-Inc/TileDB.git"
EGIT_COMMIT="9ab84f907fa5bbbc22099df220ac86f1391509f1"

PATCHES=(
	"${FILESDIR}/fix-doc-config.patch"
	"${FILESDIR}/TileDB-2.10.0-cancel-magic-download.patch"
	"${FILESDIR}/TileDB-2.10.2-cancel-capnp-download.patch"
	"${FILESDIR}/remove-incompatible-package-names.patch"
	"${FILESDIR}/fix_deprecated_sphinx_calls.patch"
)

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~x86"
IUSE="debug doc +s3 +serialization"
MAGIC_REV="5.38.1.tiledb"
CAPNPROTO_REV="v0.8.0"
CMAKE_MAKEFILE_GENERATOR=emake


BDEPEND="doc? ( dev-python/sphinx )
	 >=dev-util/cmake-3.21"

DEPEND="dev-libs/spdlog
	dev-libs/libfmt
	>=dev-cpp/catch-2
	sys-libs/zlib
	app-doc/doxygen
	app-arch/lz4
	s3? ( dev-libs/aws-sdk-cpp[access-management,s3] )
	"

src_unpack()
{
	git-r3_fetch "https://github.com/TileDB-Inc/file-windows.git" ${MAGIC_REV}
	if use serialization; then git-r3_fetch "https://github.com/capnproto/capnproto.git" ${CAPNPROTO_REV}; fi
	git-r3_src_unpack
	git-r3_checkout "https://github.com/TileDB-Inc/file-windows.git" ${MAGIC_REV}
	if use serialization; then git-r3_checkout "https://github.com/capnproto/capnproto.git" ${CAPNPROTO_REV}; fi
	mkdir -p "${BUILD_DIR}/externals/src"
	mv ${WORKDIR}/${MAGIC_REV} "${BUILD_DIR}/externals/src/ep_magic"
	if use serialization; then mv ${WORKDIR}/${CAPNPROTO_REV} "${BUILD_DIR}/externals/src/ep_capnp"; fi
}

src_prepare() {
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
	fi
	if use debug ; then
		mycmakeargs+=(-DCMAKE_BUILD_TYPE=Debug )		
	fi
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	cd ${BUILD_DIR} && make doc
	use doc && cd ${S}/doc && TILEDB_DIR="${S}" DOX_XML_DIR="${BUILD_DIR}"/xml sphinx-build -E -T -b html -d doctrees -D language=en source html
}

src_install() {
	cd ${BUILD_DIR} && DESTDIR="${D}" ${CMAKE_MAKEFILE_GENERATOR} install-tiledb
	if `use doc`
	then dodoc -r ${S}/doc/html
	fi
	einstalldocs
}

