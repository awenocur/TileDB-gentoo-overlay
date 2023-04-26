EAPI=8
SLOT=0

inherit cmake

DESCRIPTION="vcpkg is a free C/C++ package manager for acquiring and managing libraries. Choose from over 1500 open source libraries to download and build in a single step or add your own private libraries to simplify your build process. Maintained by the Microsoft C++ team and open source contributors."
HOMEPAGE="https://vcpkg.io"
SRC_URI="https://github.com/microsoft/vcpkg-tool/archive/${PV//./-}.tar.gz -> ${P}.tar.gz"

DEPEND="dev-util/cmakerc
	dev-libs/spdlog"

CMAKE_MAKEFILE_GENERATOR=emake

S="${WORKDIR}/${PN}-tool-${PV//./-}"

src_configure() {
	local mycmakeargs=(
		-DVCPKG_DEPENDENCY_EXTERNAL_FMT=TRUE
		-DVCPKG_DEPENDENCY_CMAKERC=TRUE
		-DCMakeRC_DIR=/usr/share/cmake/Modules
	)
	cmake_src_configure
}
