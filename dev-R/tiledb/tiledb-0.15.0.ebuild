# Distributed under the terms of the MIT license

EAPI=7

R_OVERRIDE_DOWNLOAD=YES
R_REQUIRE_BUILD=YES
R_BYPASS_DOCS=YES

inherit R-packages git-r3

DESCRIPTION="R interface to the storage engine of TileDB"
HOMEPAGE="https://tiledb.com/"
KEYWORDS="amd64"
LICENSE=MIT

DEPEND=">=dev-R/Rcpp-1.0.8
	dev-R/nanotime
	>=dev-db/TileDB-2.9
	dev-R/simplermarkdown"

EGIT_REPO_URI="https://github.com/TileDB-Inc/TileDB-R.git"
EGIT_COMMIT="e0e816d8cef2e0b4c048485e423f14ac518b874c"

src_install()
{
	R-packages_src_install
}