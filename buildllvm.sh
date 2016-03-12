#!/bin/sh
page_prefix=http://llvm.org/releases/
tx=.tar.xz
s=.src
stx=${s}${tx}
tool_dir=llvm/tools/
projects_dir=llvm/projects/

for item in llvm cfe compiler-rt libcxx libcxxabi openmp clang-tool-extra
do
    wget ${page_prefix}$1/${item}-$1${stx};
    tar Jxvf ${item}-$1${stx};
    mv ${item}-$1${s} ${item};
done

rm ./*.tar.xz

mv clang-tool-extra extra
mv cfe clang
mv extra clang/tools/;
mv clang ${tool_dir};

for item in libcxx libcxxabi compiler-rt openmp
do
    mv ${item} ${projects_dir};
done

mkdir build;
cd build;
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr/local/llvm/ ../llvm/;
make -j4;
