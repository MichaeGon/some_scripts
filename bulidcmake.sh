#!/bin/sh

env CC=clang CXX=clang++ ./bootstrap
make
make install
