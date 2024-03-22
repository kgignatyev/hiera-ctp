#!/usr/bin/env bash

mkdir -p tests/target
rm -fR tests/target/*

impl_name=${1}

if [[ -z ${impl_name} ]]; then
  echo "Usage: $0 <impl_name>, where impl_name is one of: java, rust, go, java-native, kotlin-native"
  exit 1
fi

if test -f test_times.txt;then
    rm test_times.txt
fi
#set -x
timeDetais=-a
#timeDetais=-al
function runTemplates() {
  echo "***************" >> test_times.txt
#asways run java as a 'benchmark'
    export PATH=$(pwd)/hiera-ctp-java/target:$PATH
    export SUFFIX="${ENVIRONMENT}_${CLUSTER_LOCATION}_${RELEASE}"
    echo "JAVA Running $(which hiera-ctp)"
    echo "JAVA_$SUFFIX" >> test_times.txt
    command time $timeDetais -o test_times.txt consul-template --vault-renew-token=false --once -template  "tests/in.tpl:tests/target/out-java_$SUFFIX.txt"



  if [[ "rust" == ${impl_name} || "all" = ${impl_name} ]]; then
    export PATH=$HOME/.cargo/bin:$PATH
    echo "RUST Running $(which hiera-ctp)"
    echo "RUST_$SUFFIX" >> test_times.txt
    command time $timeDetais -o test_times.txt  consul-template --vault-renew-token=false --once -template  "tests/in.tpl:tests/target/out-rust_$SUFFIX.txt"
      diff_result=$(diff tests/target/out-java_$SUFFIX.txt tests/target/out-rust_$SUFFIX.txt)
      if [[ 0 -eq ${diff_result} ]]; then
        echo "congratulations, rendered RUST templates are the same"
      else
        echo "ERROR: rendered by RUST templates are different"
        exit 1
      fi
  fi

  if [[ "go" == ${impl_name} || "all" = ${impl_name} ]]; then
      export PATH=$HOME/go/bin:$PATH
      echo "GO: Running $(which hiera-ctp)"
      echo "GO_$SUFFIX" >> test_times.txt
      command time $timeDetais -o test_times.txt consul-template --vault-renew-token=false --once -template  "tests/in.tpl:tests/target/out-go_$SUFFIX.txt"

       diff_result=$(diff tests/target/out-java_$SUFFIX.txt tests/target/out-go_$SUFFIX.txt)
        if [[ 0 -eq ${diff_result} ]]; then
      	 echo "congratulations, rendered GO templates are the same"
      	else
      	 echo "ERROR: rendered by GO templates are different"
      	 exit 1
        fi
  fi


  if [[ "java-native" == ${impl_name} || "all" = ${impl_name} ]]; then
    export PATH=$(pwd)/hiera-ctp-graal-native:$PATH
    echo "GRAAL: Running $(which hiera-ctp)"
    echo "JAVA-NATIVE_$SUFFIX" >> test_times.txt
    command time $timeDetais -o test_times.txt consul-template --vault-renew-token=false --once -template  "tests/in.tpl:tests/target/out-graal_$SUFFIX.txt"

      diff_result=$(diff tests/target/out-java_$SUFFIX.txt tests/target/out-graal_$SUFFIX.txt)
        if [[ 0 -eq ${diff_result} ]]; then
      	 echo "congratulations, rendered by graal templates are the same"
        else
        	 echo "ERROR: rendered by graal templates are different"
        	 exit 1
        fi
  fi


  if [[ "kotlin-native" == ${impl_name} || "all" = ${impl_name} ]]; then
    export PATH=$(pwd)/hiera-ctp-kotlin-native/build/bin/native/releaseExecutable:$PATH
    echo "KOTLIN NATIVE: Running $(which hiera-ctp)"
    echo "KOTLIN-NATIVE_$SUFFIX" >> test_times.txt
    command time $timeDetais -o test_times.txt consul-template --vault-renew-token=false --once -template  "tests/in.tpl:tests/target/out-kotlin-native_$SUFFIX.txt"

      diff_result=$(diff tests/target/out-java_$SUFFIX.txt tests/target/out-kotlin-native_$SUFFIX.txt)
        if [[ 0 -eq ${diff_result} ]]; then
      	 echo "congratulations, rendered by kotlin-native templates are the same"
        else
        	 echo "ERROR: rendered by kotlin-native templates are different"
        	 exit 1
        fi
  fi


}

export CLUSTER_LOCATION=us-west-1
export RELEASE=release1
runTemplates
export CLUSTER_LOCATION=us-east-2
runTemplates
export RELEASE=release2
runTemplates
export ENVIRONMENT=prod
runTemplates

ls -alh hiera-ctp-java/target/hiera-ctp
ls -alh $HOME/.cargo/bin/hiera-ctp
ls -alh $HOME/go/bin/hiera-ctp
ls -alh hiera-ctp-graal-native/hiera-ctp
ls -alh hiera-ctp-kotlin-native/build/bin/native/releaseExecutable/hiera-ctp
