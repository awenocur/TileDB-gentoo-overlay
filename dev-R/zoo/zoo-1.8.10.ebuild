# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit R-packages

R_OVERRIDE_DOWNLOAD=YES
SRC_URI="mirror://cran/src/contrib/${PN}_1.8-10.tar.gz"

LICENSE='GPL-2+'
KEYWORDS="amd64"
