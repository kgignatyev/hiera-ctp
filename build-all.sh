#!/usr/bin/env bash

set -e

cd  hiera-ctp-rust

./build.sh


cd ../hiera-ctp-java
source ../j11.sh
./build.sh

cd ../hiera-ctp-graal-native
source ../gvm.sh
./build.sh



cd ../hiera-ctp-go

./build.sh


cd ..