#!/usr/bin/env bash

set -e

mvn install
cat stub.sh target/hiera-ctp-0.1-SNAPSHOT-spring-boot.jar > target/hiera.jar
chmod u+x target/hiera.jar