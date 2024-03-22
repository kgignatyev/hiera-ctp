#!/usr/bin/env bash

set -e

if test -f build_times.txt;then
    rm build_times.txt
fi

for d in hiera-ctp-rust hiera-ctp-java hiera-ctp-graal-native hiera-ctp-go hiera-ctp-kotlin-native;do
    cd $d
    echo "Building $d" >> ../build_times.txt
    command time -a -o ../build_times.txt  ./build.sh
    pwd
    cd ..
done
