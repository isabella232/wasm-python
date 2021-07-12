#!/usr/bin/env bash
set -ev

export PREFIX=`pwd`/../../build/local/

emcc interface.c  -o interface.js \
    -I $PREFIX/include/python3.9 -L $PREFIX/lib/ \
    -lpython3.9 -ldl  -lm \
    -s MODULARIZE=1 \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s EXPORTED_FUNCTIONS='["_init", "_pyeval", "_finalize"]' \
    -s EXPORTED_RUNTIME_METHODS='["cwrap"]' \
    --preload-file $PREFIX/lib/python3.9
