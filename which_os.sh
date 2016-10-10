#! /bin/sh

if [ "$(uname)" == 'Darwin' ]; then
    res='dawrin'
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    res='linux'
else
    echo "unknown platform (($uname -a))"
    exit 1
fi

echo ${res}
