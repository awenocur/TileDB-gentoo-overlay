# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
SLOT=0
LICENSE="MIT"

PYTHON_COMPAT=( python3_{6..10} )
inherit distutils-r1 git-r3

SRC_URI="https://files.pythonhosted.org/packages/e6/e2/f2bfdf364e016f7a464db709ea40d1101c4c5a463dd7019dae0a42dbd1c6/setuptools-59.5.0.tar.gz
	 https://github.com/pypa/wheel/archive/0.37.1.tar.gz -> wheel-0.37.1.gh.tar.gz"

EGIT_REPO_URI="https://github.com/TileDB-Inc/TileDB-Py.git"
EGIT_COMMIT="648546ce7bb1ee609e0d27fedbf287e665afdf2d"

PATCHES=("${FILESDIR}/allow_any_cmake.patch")

S="${WORKDIR}/${P}"

PYTHON_REQ_USE="threads(+)"

KEYWORDS="amd64 ~x86"
IUSE="debug"

DEPEND=">=dev-db/TileDB-2.9
	>=dev-python/pybind11-2.3.0[${PYTHON_USEDEP}]"

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