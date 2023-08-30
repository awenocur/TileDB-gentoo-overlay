# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
SLOT=3
LICENSE="MIT"

PATCHES=("${FILESDIR}/TileDB-VCF-0.25.0-disable-ext-build.patch")

PYTHON_COMPAT=( python3_{6..10} )
inherit distutils-r1 git-r3

EGIT_REPO_URI="https://github.com/TileDB-Inc/TileDB-VCF.git"
EGIT_BRANCH=release-0.25
EGIT_COMMIT="9518b49e054704e8515eec4a4e72f0b113236dda"

S="${WORKDIR}/${P}/apis/python"

PYTHON_REQ_USE="threads(+)"

KEYWORDS="amd64 ~x86"
IUSE="debug"
#DISTUTILS_USE_SETUPTOOLS=bdepend

DEPEND="=sci-biology/TileDB-VCF-${PV}
	>=dev-python/pyarrow-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/pybind11-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/dask-0.19.0[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]"

DESCRIPTION="The Universal Storage Engine"
HOMEPAGE="https://tiledb.com/"

DISTUTILS_ARGS=("--libtiledbvcf=/usr/"
		"--disable-download-tiledb-prebuilt")
python_configure_all() {
	if use debug ; then
	   DISTUTILS_ARGS+=( "--debug" )
	fi
}
