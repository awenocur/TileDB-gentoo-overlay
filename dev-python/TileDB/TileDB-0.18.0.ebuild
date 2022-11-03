# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
SLOT=0
LICENSE="MIT"

PYTHON_COMPAT=( python3_{6..10} )
inherit distutils-r1 git-r3

EGIT_REPO_URI="https://github.com/TileDB-Inc/TileDB-Py.git"
EGIT_COMMIT="b10dfb271b39962b5d7ef9a7e1559e7812786b96"

PATCHES=("${FILESDIR}/TileDB-0.17.4-requirements.patch"
	"${FILESDIR}/TileDB-0.17.4-allow_any_cmake.patch")

S="${WORKDIR}/${P}"

PYTHON_REQ_USE="threads(+)"

KEYWORDS="amd64 ~x86"
IUSE="debug"

DEPEND=">=dev-db/TileDB-2.9
	>=dev-python/pybind11-2.3.0[${PYTHON_USEDEP}]
	dev-python/pip
	dev-python/cython
	>=dev-python/numpy-1.16.5"

DESCRIPTION="The Universal Storage Engine"
HOMEPAGE="https://tiledb.com/"

DISTUTILS_ARGS=("--tiledb=/usr")

python_configure_all() {
	if use debug ; then
	   DISTUTILS_ARGS+=( "--debug" )
	fi
}
