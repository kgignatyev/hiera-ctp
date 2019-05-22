#!/usr/bin/env bash

cargo  build --release --features "derive"
cargo install --force  --path=.