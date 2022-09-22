# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
SLOT=0
LICENSE="MIT"

PYTHON_COMPAT=( python3_{6..10} )
inherit distutils-r1 git-r3

EGIT_REPO_URI="https://github.com/TileDB-Inc/TileDB-Cloud-Py.git"
EGIT_COMMIT="13da4acd5e7dea9ecb0408fdeb9ae6fd244e24d4"

S="${WORKDIR}/${P}"

PYTHON_REQ_USE="threads(+)"

KEYWORDS="amd64 ~x86"

BDEPEND="dev-python/setuptools"

DESCRIPTION="The Universal Storage Engine"
HOMEPAGE="https://tiledb.com/"
