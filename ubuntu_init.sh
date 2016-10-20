#! /bin/sh

sudo su << EOF

apt-get update && apt-get upgrade -y

apt-get install -y software-properties-common git git-flow vim cmake make gcc g++ zlib1g-dev sl zsh

add-apt-repository -y ppa:webupd8team/atom
add-apt-repository -y ppa:ubuntu-lxc/lxd-stable

apt-get update

apt-get install -y atom golang

EOF
