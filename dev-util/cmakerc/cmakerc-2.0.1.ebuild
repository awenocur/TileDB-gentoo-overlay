EAPI=8
SLOT=0

KEYWORDS="amd64"

DESCRIPTION="A Standalone CMake-Based C++ Resource Compiler"
SRC_URI="https://github.com/vector-of-bool/cmrc/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/cmrc-${PV}"

src_install() {
    insinto /usr/share/cmake/Modules
    doins CMakeRC.cmake
    doins "${FILESDIR}/cmakerc-config.cmake"
}
