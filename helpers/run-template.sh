#!/usr/bin/env bash

set -e

consul-template -template "in.tpl:out.txt" -once

cat out.txt 