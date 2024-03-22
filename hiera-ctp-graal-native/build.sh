#!/usr/bin/env bash

set -e
source ../gvm.sh

mvn clean install
native-image --report-unsupported-elements-at-runtime \
  --no-fallback  \
  --enable-http  \
  -jar target/hiera-ctp-graal-native-0.1-SNAPSHOT-jar-with-dependencies.jar hiera-ctp

