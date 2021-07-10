#!/usr/bin/env bash
set -ev
cd $BUILD

curl https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz -o Python-$PYTHON_VERSION.tar.xz
tar xvf Python-$PYTHON_VERSION.tar.xz
cd Python-$PYTHON_VERSION

cat $SRC/python-patches/*.patch | patch -p1

cp $SRC/config.site .

# We use wasm_32-unknown-emscripten instead of just "wasm32-unknown-emscripten"
# (which is what pyodide does) so that "make install" below works.
time CONFIG_SITE=./config.site READELF=true emconfigure ./configure --prefix=$PREFIX \
    --enable-big-digits=30 \
    --enable-optimizations \
    --disable-shared \
    --disable-ipv6 \
    --host=wasm_32-unknown-emscripten \
    --build=`./config.guess`

time emmake make -j8

time emmake make install

# Now gets hackish
# Rebuild python interpreter with the entire Python library as a filesystem:
emcc -o python.js Programs/python.o libpython3.9.a -ldl  -lm --lz4   --preload-file $PREFIX/lib/python3.9 -s ALLOW_MEMORY_GROWTH=1 -s ASSERTIONS=0

mkdir -p $DIST
cp python.js python.data python.wasm $DIST

# Now we can do
#  node ./python -c 'print("hello world", 2+3)'
# and get
#  hello world 5
# However, just "node ./python" doesn't work, since it terminates instead of waiting for input.
# But we *don't* want the Python repl.  We want a function that evaluates a block of code, so
# we can build a Jupyter kernel, node.js library interface, etc.
