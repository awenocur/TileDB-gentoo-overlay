# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

R_OVERRIDE_DOWNLOAD=YES

inherit R-packages git-r3

DESCRIPTION="R interface to the storage engine of TileDB"
HOMEPAGE="https://tiledb.com/"
KEYWORDS="~amd64"
LICENSE=MIT

DEPEND=">=dev-R/Rcpp-1.0.8
	dev-R/nanotime
	>=dev-db/TileDB-2.9"

EGIT_REPO_URI="https://github.com/TileDB-Inc/TileDB-R.git"
EGIT_COMMIT="b3bcc7da2539b3801fa2e7c40ae89e29a55f8ddb"
