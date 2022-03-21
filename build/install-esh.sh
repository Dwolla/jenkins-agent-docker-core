#!/bin/bash
set -eu

umask 077

cleanup () {
  set +u
  rm -fr "$gpg_homedir" "$eshdir"
  set -u
}

trap "cleanup" EXIT HUP INT TERM

usage () {
    echo "Usage: $0 <tag>" >&2
    exit 1
}

if [[ "$#" -ne 1 ]]; then
    usage
fi

readonly esh_tag="$1"
readonly gpg_homedir="$(mktemp -d esh-gpghome.XXXXXXXXXX)"
readonly eshdir="$(mktemp -d esh-repo.XXXXXXXXXX)"
export GNUPGHOME="$gpg_homedir"
mkdir -p "$gpg_homedir"

gpg --quiet --receive-keys F95BD679104D3115
declare -r gpg_import_result=$?

if [ "$?" != "0" ] && [ "$gpg_import_result" != "2" ]; then
    echo "Failed to import GPG key" >&2
    exit 1
fi

git clone --quiet -b "$esh_tag" --depth 1 https://github.com/jirutka/esh.git "$eshdir"

if ! git --git-dir="$eshdir/.git" verify-tag "$esh_tag"; then
    echo "Tag $esh_tag not signed" >&2
    exit 1
fi

cp "${eshdir}/esh" /bin/esh
