#! /bin/sh

if [ "$(uname)" == 'Darwin' ]; then
    res='Mac'
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    res='Linux'
elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
    res='Cygwin'
else
    echo "unknown platform (($uname -a))"
    exit 1
fi

echo ${res}
