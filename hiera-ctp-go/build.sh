#!/usr/bin/env bash

export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin

if test -f $HOME/go/bin/hiera-ctp;then
   echo "Removing old binary"
   rm ~/go/bin/hiera-ctp
fi

go build
go install
mv ~/go/bin/hiera-ctp-go ~/go/bin/hiera-ctp
