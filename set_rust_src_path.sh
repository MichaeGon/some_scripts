#! /bin/sh

if [ $# -lt 1 ] ; then
    echo "no arguments"
    exit 1
fi

if [ $# -gt 1 ] ; then
    echo "too many arguments"
    exit 1
fi

page_prefix=https://static.rust-lang.org/dist/
src_prefix=rustc-
src_postfix=-src
src_ext=.tar.gz

src_dir=${src_prefix}${1}${src_postfix}
src_path=${page_prefix}${src_dir}${src_ext}

# paths?

wget ${src_path}
tar xvf ${src_dir}${src_ext}

# undefined
