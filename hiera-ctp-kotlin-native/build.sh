#!/usr/bin/env bash

set -e
./gradlew clean build
cp build/bin/native/releaseExecutable/hiera-ctp.kexe build/bin/native/releaseExecutable/hiera-ctp
