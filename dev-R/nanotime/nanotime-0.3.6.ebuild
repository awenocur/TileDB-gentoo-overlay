# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit R-packages

DEPEND="dev-R/Rcpp
	dev-R/bit64
	dev-R/RcppCCTZ
	dev-R/RcppDate
	dev-R/zoo"
LICENSE='GPL-2+'
KEYWORDS="amd64"
