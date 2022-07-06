# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
SLOT=3
LICENSE="MIT"

PATCHES=("${FILESDIR}/disable-ext-build.patch")

PYTHON_COMPAT=( python3_{6..10} )
inherit distutils-r1

SRC_URI="https://github.com/TileDB-Inc/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${P}/apis/python"

PYTHON_REQ_USE="threads(+)"

KEYWORDS="amd64 ~x86"

#DISTUTILS_USE_SETUPTOOLS=bdepend

DEPEND="=sci-biology/TileDB-VCF-${PV}
	>=dev-python/pyarrow-3.0.0
	>=dev-python/pybind11-2.3.0
	>=dev-python/dask-0.19.0
	dev-python/pip
	dev-python/setuptools_scm_git_archive"

DESCRIPTION="The Universal Storage Engine"
HOMEPAGE="https://tiledb.com/"

DISTUTILS_ARGS=("--libtiledbvcf=/usr/"
		"--disable-download-tiledb-prebuilt")
