#!/bin/bash
set -exo pipefail

cd /src

go mod download
go generate ./...

.travis-ci/compile.sh
go test -failfast -race -v -cover ./...
