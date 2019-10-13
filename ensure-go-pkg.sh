#!/bin/bash
set -exo pipefail

PKGPATH="/go/src/$1"
PARENT="$(dirname "$PKGPATH")"

mkdir -p "$PARENT"
cd "$PARENT"
git clone "$2"
cd "$PKGPATH"
git checkout "$3"
rm -rf .git
