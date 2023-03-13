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
	dev-R/simplermarkdown
	dev-R/spdl"

EGIT_REPO_URI="https://github.com/TileDB-Inc/TileDB-R.git"
EGIT_COMMIT="a7b8e229c6530c82d47b0e61dabc4f8b2a2b1979"

src_install()
{
	R-packages_src_install
}