#! /bin/sh

if [ $# -lt 1 ] ; then
    echo "no arguments"
    exit 1
fi

if [ $# -gt 1 ] ; then
    echo "too many arguments"
    exit 1
fi

rust_src_path=`echo $RUST_SRC_PATH`

if [ -z "${rust_src_path}" ] ; then
    echo "not found RUST_SRC_PATH"
    exit 1
fi

page_prefix=https://static.rust-lang.org/dist/
src_prefix=rustc-
src_ext=-src.tar.gz

src_dir=${src_prefix}${1}
src_path=${page_prefix}${src_dir}${src_ext}


wget ${src_path}
tar xvf ${src_dir}${src_ext}

rm -rf ${rust_src_path}
mkdir -p ${rust_src_path}

mv ${src_dir}/src/* ${rust_src_path}

rm ${src_dir}${src_ext}
rm -rf ${src_dir}
