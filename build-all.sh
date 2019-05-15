#!/usr/bin/env bash

set -e

cd  hiera-ctp-rust

./build.sh

cd ../hiera-ctp-java

./build.sh

cd ../hiera-ctp-go

./build.sh


cd ..