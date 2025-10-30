#!/bin/bash
set -o errexit -o nounset -o pipefail
IFS=$'\n\t'

umask 077

readonly ORIGINAL_PWD="$PWD"

cleanup () {
  set +o nounset
  cd "${ORIGINAL_PWD}"
  if [ -n "${version-}" ]; then
    rm -rf "esh-${version}"
    rm -f "esh-${version}.tar.gz"
  fi
  set -o nounset
}

trap cleanup EXIT HUP INT TERM

usage () {
    echo "Usage: $0 <tag>" >&2
    exit 1
}

if [[ "$#" -ne 1 ]]; then
    usage
fi

readonly esh_tag="$1"
readonly version="${esh_tag#v}"

curl --location \
  --output "esh-${version}.tar.gz" \
  "https://github.com/jirutka/esh/archive/${esh_tag}/esh-${version}.tar.gz"
tar -xzf "esh-${version}.tar.gz"
cd "esh-${version}"
make test
make install prefix=/usr/local DESTDIR=/
