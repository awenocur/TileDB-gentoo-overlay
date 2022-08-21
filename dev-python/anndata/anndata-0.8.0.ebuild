# Distributed under the terms of the MIT license

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )
inherit python-r1
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
DEPEND=">=dev-python/pandas-1.1.1
	>=dev-python/numpy-1.16.5
	>=dev-python/scipy-1.4
	>=dev-python/h5py-3
	dev-python/natsort
	>=dev-python/packaging-20"

DESCRIPTION="anndata is a Python package for handling annotated data matrices in memory and on disk, positioned between pandas and xarray. anndata offers a broad range of computationally efficient features including, among others, sparse data support, lazy operations, and a PyTorch interface."
HOMEPAGE="https://github.com/scverse/anndata"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

generate_egg_info()
{
	mkdir ${P}-${EPYTHON//python/py}.egg-info
	cp ${S}/PKG-INFO ${P}-${EPYTHON//python/py}.egg-info
	local sitedir=$(python_get_sitedir)
	d=${sitedir#${EPREFIX}}/${_PYTHON_MODULEROOT//.//}
	#cp -R ${P}-${EPYTHON//python/py}.egg-info ${d}
	insinto "${d}"
	doins -r ${P}-${EPYTHON//python/py}.egg-info
}

src_install() {
	python_foreach_impl python_domodule anndata
	python_foreach_impl run_in_build_dir generate_egg_info
}