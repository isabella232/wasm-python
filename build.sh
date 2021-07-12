#!/usr/bin/env bash
set -ev

. ./src/build/build-env.sh

rm -rf $BUILD
mkdir $BUILD

./src/build/build-python.sh