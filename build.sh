#!/usr/bin/env bash
set -ev

. ./src/build-env.sh

rm -rf $BUILD
mkdir $BUILD

./src/build-python.sh