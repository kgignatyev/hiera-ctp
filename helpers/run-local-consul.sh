#!/usr/bin/env bash

CDATA=data/consul

mkdir -p ${CDATA}

consul agent   -bind "0.0.0.0" -client "0.0.0.0"  -server -ui -dev -data-dir=${CDATA}