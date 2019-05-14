#!/usr/bin/env bash

mkdir -p tests/target


export PATH=hiera-ctp-java/target:$PATH

time consul-template --vault-renew-token=false --once -template  "tests/in.tpl:tests/target/out-java.txt"



export PATH=$HOME/.cargo/bin:$PATH


time consul-template --vault-renew-token=false --once -template  "tests/in.tpl:tests/target/out-rust.txt"


diff_result=$(diff tests/target/out-java.txt tests/target/out-rust.txt)

if [[ 0 -eq ${diff_result} ]]; then
  echo "congratulations, rendered templates are the same"
fi
