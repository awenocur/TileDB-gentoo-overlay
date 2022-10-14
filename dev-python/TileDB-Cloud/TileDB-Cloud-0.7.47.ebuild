# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
SLOT=0
LICENSE="MIT"

PYTHON_COMPAT=( python3_{6..10} )
inherit distutils-r1 git-r3

EGIT_REPO_URI="https://github.com/TileDB-Inc/TileDB-Cloud-Py.git"
EGIT_COMMIT="679c3ba89279b581560f8657dbbfad36588a02b4"

S="${WORKDIR}/${P}"

PYTHON_REQ_USE="threads(+)"

KEYWORDS="amd64 ~x86"

RDEPEND="
        dev-python/pyarrow
        dev-python/TileDB
        dev-python/attrs
	dev-python/urllib3
	=dev-python/cloudpickle-TileDB-1.4.1
	"
BDEPEND="dev-python/setuptools"

DESCRIPTION="The Universal Storage Engine"
HOMEPAGE="https://tiledb.com/"

src_prepare()
{
	default
	for file in $(find "${S}" -type f -exec grep -l '^import cloudpickle' \{} \;)
		do printf '%s\n%s\n' ',s/^import cloudpickle$/import tiledb.cloud.cloudpickle as cloudpickle/' 'wq' | ed "${file}"
	done
	cp ${FILESDIR}/cloudpickle.py ${S}/tiledb/cloud
}