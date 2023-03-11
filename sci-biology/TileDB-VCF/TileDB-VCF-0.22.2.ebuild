# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="The Universal Storage Engine"
HOMEPAGE="https://tiledb.com/"

EGIT_REPO_URI="https://github.com/TileDB-Inc/TileDB-VCF.git"
EGIT_BRANCH=release-0.22
EGIT_COMMIT="7eae0d1d7014953448a9edb6de4f46e0bfe0776c"

PATCHES=( "${FILESDIR}/${PN}-0.18.0-disable-debug-sanitize-check.patch" )

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~x86"
IUSE="debug address-sanitize"
S="${WORKDIR}/${P}/libtiledbvcf"
CMAKE_MAKEFILE_GENERATOR=emake

DEPEND=">=dev-db/TileDB-2.9
	sci-libs/htslib
	dev-cpp/cli11[single-header]
	>=dev-libs/spdlog-1.9
	<dev-libs/libfmt-8.1"

BDEPEND="<dev-cpp/catch-2
	dev-cpp/clipp"

src_prepare() {
	cmake_src_prepare
	echo ',s/\(^ *[A-Z]* DESTINATION \)lib$/\1'"$(get_libdir)"'/
w' | ed -s ${S}/src/CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_C_FLAGS=-DSPDLOG_FMT_EXTERNAL
		-DCMAKE_CXX_FLAGS=-DSPDLOG_FMT_EXTERNAL
		-DFORCE_EXTERNAL_HTSLIB=OFF
		-DFORCE_EXTERNAL_TILEDB=OFF
		-DCATCH_INCLUDE_DIR=/usr/include/catch
	)
	if use debug ; then
		mycmakeargs+=(-DCMAKE_BUILD_TYPE=Debug
		-DCMAKE_C_FLAGS=-O0\ -ggdb
		-DCMAKE_CXX_FLAGS=-O0\ -ggdb)
	fi
	if use address-sanitize ; then
		mycmakeargs+=(-DSANITIZER=address )		
	fi
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cd ${BUILD_DIR} && DESTDIR="${D}" ${CMAKE_MAKEFILE_GENERATOR} install-libtiledbvcf
	einstalldocs
}

