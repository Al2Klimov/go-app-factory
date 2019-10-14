#!/bin/bash
set -exo pipefail

cd /go/src/*/*/*

dep ensure
.travis-ci/compile.sh
go test -failfast -race -v -cover ./...
