#!/bin/sh
page_prefix=http://llvm.org/releases/
tx=.tar.xz
s=.src
stx=${s}${tx}
tool_dir=llvm/tools/
projects_dir=llvm/projects/

if [ $# -lt 1 ] ; then
    echo "no arguments"
    exit 1
fi

if [ $# -gt 1 ] ; then
    echo "too many arguments"
    exit 1
fi


for item in llvm cfe compiler-rt libcxx libcxxabi openmp clang-tools-extra
do
    wget ${page_prefix}${1}/${item}-${1}${stx}
    tar Jxvf ${item}-${1}${stx}
    mv ${item}-${1}${s} ${item}
done

rm ./*${tx}

mv clang-tools-extra extra
mv cfe clang
mv extra clang/tools/
mv clang ${tool_dir}

for item in libcxx libcxxabi compiler-rt openmp
do
    mv ${item} ${projects_dir}
done

mkdir build
cd build
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr/local/llvm/ -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly ../llvm/
make -j4
