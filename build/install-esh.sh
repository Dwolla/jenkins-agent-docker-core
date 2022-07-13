#!/bin/bash
set -o errexit -o nounset -o pipefail
IFS=$'\n\t'

umask 077

cleanup () {
  set +o nounset
  rm -fr "$gpg_homedir" "$esh_dir"
  set -o nounset
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

gpg_homedir="$(mktemp -d esh-gpghome.XXXXXXXXXX)"
esh_dir="$(mktemp -d esh-repo.XXXXXXXXXX)"
readonly gpg_homedir esh_dir

export GNUPGHOME="$gpg_homedir"
mkdir -p "$gpg_homedir"

set -x

if ! gpg --receive-keys F95BD679104D3115; then
    echo "Failed to import GPG key" >&2
    exit 1
fi

git clone \
  --branch "$esh_tag" \
  --depth 1 \
  https://github.com/jirutka/esh.git \
  "$esh_dir"

if ! git --git-dir="$esh_dir/.git" verify-tag "$esh_tag"; then
    echo "Tag $esh_tag not signed" >&2
    exit 1
fi

cp "${esh_dir}/esh" /bin/esh

chmod 0555 /bin/esh
