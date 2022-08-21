# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

XTENSOR_XSIMD_HASH=7d1778c3b38d63db7cec7145d939f40bc5d859d1

DESCRIPTION="Cross-language development platform for in-memory data (C++ interface)"
HOMEPAGE="https://arrow.apache.org/"
SRC_URI="https://github.com/apache/arrow/archive/apache-arrow-${PV}.tar.gz
	https://github.com/xtensor-stack/xsimd/archive/${XTENSOR_XSIMD_HASH}.tar.gz -> xtensor-xsimd-${XTENSOR_XSIMD_HASH}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/80"
KEYWORDS="amd64"

IUSE="brotli ccache deprecated glog lz4 openssl parquet +snappy static-libs +zlib zstd"

S="${WORKDIR}/arrow-apache-arrow-${PV}/cpp"
CMAKE_BUILD_TYPE="release"

COMMON_DEPEND="
	dev-cpp/gflags:=
	dev-libs/boost:=
	dev-libs/double-conversion:=
	dev-libs/rapidjson
	dev-libs/thrift:=
	dev-libs/flatbuffers
	ccache? ( dev-util/ccache )
	glog? ( dev-cpp/glog )
	openssl? ( dev-libs/openssl:= )
	dev-libs/libutf8proc
	app-arch/snappy
	dev-libs/re2
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

# Testing requires files from https://github.com/apache/parquet-testing
RESTRICT="test"

src_unpack() {
	unpack apache-arrow-${PV}.tar.gz
	cp ${DISTDIR}/xtensor-xsimd-${XTENSOR_XSIMD_HASH}.tar.gz ${WORKDIR}/${XTENSOR_XSIMD_HASH}.tar.gz
}

src_prepare() {
	cmake_src_prepare
	mkdir ${BUILD_DIR}/src
	mv ${WORKDIR}/${XTENSOR_XSIMD_HASH}.tar.gz ${BUILD_DIR}/src
}

# - Arrow forces shipped jemalloc => disable
src_configure() {
	local mycmakeargs=(
		-DARROW_PYTHON=ON
		-DARROW_ALTIVEC=OFF
		-DARROW_BUILD_STATIC="$(usex static-libs)"
		-DARROW_JEMALLOC=OFF
		-DARROW_NO_DEPRECATED_API="$(usex !deprecated)"
		-DARROW_PARQUET="$(usex parquet)"
		-DARROW_USE_GLOG="$(usex glog)"
		-DARROW_VERBOSE_THIRDPARTY_BUILD=OFF
		-DARROW_WITH_BROTLI="$(usex brotli)"
		-DARROW_WITH_LZ4="$(usex lz4)"
		-DARROW_WITH_SNAPPY="$(usex snappy)"
		-DARROW_WITH_ZLIB="$(usex zlib)"
		-DARROW_WITH_ZSTD="$(usex zstd)"
	)
	cmake_src_configure
}
