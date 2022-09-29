# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

S=${S%${P}}${PN%%-TileDB}-${PV}

DESCRIPTION="Extended pickling support for Python objects"
HOMEPAGE="
	https://pypi.org/project/cloudpickle/
	https://github.com/cloudpipe/cloudpickle/"
SRC_URI="mirror://pypi/${PN::1}/${PN%%-TileDB}/${PN%%-TileDB}-${PV}.tar.gz"
PATCHES=( "${FILESDIR}/rename-package.patch" )

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

src_prepare() {
	default
	mkdir "${S}/tiledb"
	mv "${S}/cloudpickle" "${S}/tiledb"
}

python_test() {
	# -s unbreaks some tests
	# https://github.com/cloudpipe/cloudpickle/issues/252
	pytest -svv || die "Tests fail with ${EPYTHON}"
}
