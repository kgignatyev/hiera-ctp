#!/usr/bin/env bash

mkdir -p tests/target

function runTemplates() {
  source j11.sh
  export PATH=hiera-ctp-java/target:$PATH
  export SUFFIX="${ENVIRONMENT}_${CLUSTER_LOCATION}_${RELEASE}"
  echo "Running $(which hiera-ctp)"
  time consul-template --vault-renew-token=false --once -template  "tests/in.tpl:tests/target/out-java-$SUFFIX.txt"
  export PATH=$HOME/.cargo/bin:$PATH
  echo "Running $(which hiera-ctp)"
  time consul-template --vault-renew-token=false --once -template  "tests/in.tpl:tests/target/out-rust-$SUFFIX.txt"
  export PATH=$HOME/go/bin:$PATH
  echo "Running $(which hiera-ctp)"
  time consul-template --vault-renew-token=false --once -template  "tests/in.tpl:tests/target/out-go-$SUFFIX.txt"

  export PATH=hiera-ctp-graal-native:$PATH
  echo "Running $(which hiera-ctp)"
  time consul-template --vault-renew-token=false --once -template  "tests/in.tpl:tests/target/out-graal-$SUFFIX.txt"


  diff_result=$(diff tests/target/out-java-$SUFFIX.txt tests/target/out-rust-$SUFFIX.txt)
  if [[ 0 -eq ${diff_result} ]]; then
    echo "congratulations, rendered templates are the same"
  fi
  diff_result=$(diff tests/target/out-go-$SUFFIX.txt tests/target/out-rust-$SUFFIX.txt)
  if [[ 0 -eq ${diff_result} ]]; then
	 echo "congratulations, rendered go templates are the same"
  fi
  diff_result=$(diff tests/target/out-graal-$SUFFIX.txt tests/target/out-rust-$SUFFIX.txt)
    if [[ 0 -eq ${diff_result} ]]; then
  	 echo "congratulations, rendered by graal templates are the same"
    fi
}

export CLUSTER_LOCATION=us-west-1
export RELEASE=release1
runTemplates
export CLUSTER_LOCATION=us-east-2
runTemplates
export RELEASE=release2
runTemplates
export RELEASE=release2
runTemplates
export ENVIRONMENT=prod
runTemplates

ls -alh hiera-ctp-java/target/hiera-ctp
ls -alh $HOME/.cargo/bin/hiera-ctp
ls -alh $HOME/go/bin/hiera-ctp
ls -alh hiera-ctp-graal-native/hiera-ctp