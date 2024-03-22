#!/usr/bin/env bash
if test -f target/release/hiera-ctp;then
   echo "Removing old binary"
   rm target/release/hiera-ctp
fi

cargo  build --release --features "derive"
cargo install --force  --path=.
