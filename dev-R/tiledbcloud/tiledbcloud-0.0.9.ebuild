# Distributed under the terms of the MIT license

EAPI=7

R_OVERRIDE_DOWNLOAD=YES
R_REQUIRE_BUILD=YES
R_BYPASS_DOCS=YES

inherit R-packages git-r3

DESCRIPTION="R client for the TileDB Cloud service"
HOMEPAGE="https://tiledb.com/"
KEYWORDS="amd64"
LICENSE=MIT

DEPEND="dev-R/tiledb"

EGIT_REPO_URI="https://github.com/TileDB-Inc/TileDB-Cloud-R.git"
EGIT_BRANCH=master
EGIT_COMMIT="564c12a684d0c0d93aa165f7ffc51434dc87631c"

src_install()
{
	R-packages_src_install
}