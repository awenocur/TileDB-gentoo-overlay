# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
SLOT=0
LICENSE="MIT"

PYTHON_COMPAT=( python3_{6..10} )
inherit distutils-r1 git-r3

PATCHES=("${FILESDIR}/TileDB-0.17.4-requirements.patch"
	"${FILESDIR}/TileDB-0.17.4-allow_any_cmake.patch")

SRC_URI="https://files.pythonhosted.org/packages/80/98/8de0fd3e86d8286a2594e3fa6afc46d751130d26ebb7b1f34e9067992c6f/setuptools-58.3.0.tar.gz
	 https://github.com/pypa/wheel/archive/0.37.1.tar.gz -> wheel-0.37.1.gh.tar.gz"

EGIT_REPO_URI="https://github.com/TileDB-Inc/TileDB-Py.git"
EGIT_COMMIT="93df0befc2c6758d0161cb1c99509c33d3a458ad"

S="${WORKDIR}/${P}"

PYTHON_REQ_USE="threads(+)"

KEYWORDS="amd64 ~x86"
IUSE="debug"

DEPEND=">=dev-db/TileDB-2.14
	>=dev-python/pybind11-2.3.0[${PYTHON_USEDEP}]
	dev-python/pip
	dev-python/cython
	>=dev-python/numpy-1.16.5"

DESCRIPTION="The Universal Storage Engine"
HOMEPAGE="https://tiledb.com/"

DISTUTILS_ARGS=("--tiledb=/usr")

src_prepare()
{
	cp -pR ${DISTDIR} ${WORKDIR}/distdir
	mv ${WORKDIR}/distdir/wheel-0.37.1.gh.tar.gz ${WORKDIR}/distdir/wheel-0.37.1.tar.gz
	default
}

python_configure_all() {
	if use debug ; then
	   DISTUTILS_ARGS+=( "--debug" )
	fi
}

src_compile()
{
	export PIP_FIND_LINKS="file://${WORKDIR}/distdir"
	export PIP_CONFIG_FILE="${FILESDIR}/pip.cfg"
	export PIP_VERBOSE=3
	distutils-r1_src_compile
	rm -fR "${ED}"/usr/lib/python*/site-packages/_distutils_hack
	rm -fR "${ED}"/usr/lib/python*/site-packages/wheel
	rm -fR "${ED}"/usr/lib/python*/site-packages/setuptools
	rm -fR "${ED}"/usr/lib/python*/site-packages/pkg_resources

}

src_install()
{
	distutils-r1_src_install
	rm -fR "${ED}"/usr/lib/python*/site-packages/_distutils_hack
	rm -fR "${ED}"/usr/lib/python*/site-packages/wheel
	rm -fR "${ED}"/usr/lib/python*/site-packages/setuptools
	rm -fR "${ED}"/usr/lib/python*/site-packages/pkg_resources
}