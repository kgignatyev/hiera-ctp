#!/usr/bin/env bash

set -e
source ../j21.sh
mvn clean package
cat stub.sh target/hiera-ctp-0.1-SNAPSHOT-spring-boot.jar > target/hiera-ctp
chmod u+x target/hiera-ctp
