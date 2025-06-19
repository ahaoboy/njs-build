#!/bin/bash

if [ $# -ne 1 ]; then
    echo "not found target"
    exit 1
fi

TARGET=$1

git clone https://github.com/nginx/njs.git njs --depth=1
cd njs

# njs-ng
git clone https://github.com/quickjs-ng/quickjs quickjs-ng
git checkout v0.9.0
cd quickjs-ng
cmake -B build
cmake --build build --target njs

./configure \
          --with-quickjs \
          --cc-opt="$CC_OPT -Iquickjs-ng" \
          --ld-opt="$LD_OPT -Lquickjs-ng/build" \
|| cat build/autoconf.err
make


# njs
# git clone https://github.com/bellard/quickjs
# cd quickjs
# make libquickjs.a
# cd ..

# ./configure \
#           --with-quickjs \
#           --cc-opt="$CC_OPT -Iquickjs" \
#           --ld-opt="$LD_OPT -Lquickjs" \
# || cat build/autoconf.err
# make

mkdir ../dist

cp ./build/njs ../dist
cp ./build/libqjs* ../dist
cp ./build/libnjs* ../dist

cd ..

ls -lh dist

tar -czf ./njs-${TARGET}.tar.gz -C dist .
ls -l ./njs-${TARGET}.tar.gz