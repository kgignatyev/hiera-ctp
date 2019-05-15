#!/usr/bin/env bash

export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin


go build
go install
mv ~/go/bin/hiera-ctp-go ~/go/bin/hiera-ctp
