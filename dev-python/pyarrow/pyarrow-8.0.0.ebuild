# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

LICENSE="Apache-2.0"
SLOT="0"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
DEPEND=">=dev-python/numpy-0.14
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	>=dev-python/setuptools-38.6.0[${PYTHON_USEDEP}]
	>=dev-cpp/arrow-8
	dev-python/cython[${PYTHON_USEDEP}]"

BDEPEND="
	test? (
		dev-python/cffi
		dev-python/hypothesis
		dev-python/pandas
		dev-python/pytest-lazy-fixture
		dev-python/pytz
	)"

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest
