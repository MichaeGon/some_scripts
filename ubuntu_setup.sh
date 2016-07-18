#!/bin/sh

if [ $# -lt 1 ] ; then
    echo "usage: ./ubuntu_setup.sh <llvm version>"
    exit 1
fi

printf "password:"
read password

codename=`lsb_release -a | grep Codename | awk '{print $2}'`
llvmdir=${HOME}/llvm/build/${1}
giturl=https://raw.githubusercontent.com/MichaeGon/some_scripts/master
bl=buildllvm.sh
pk=packages.sh
brc=${HOME}/.bashrc

sudo -k

echo ${password} | sudo -S sh <<SCRIPT

# atom
add-apt-repository ppa:webupd8team/atom
# java
add-apt-repository ppa:webupd8team/java
# stack
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 575159689BEFB442
echo "deb http://download.fpcomplete.com/ubuntu ${codename} main" | \
tee /etc/apt/sources.list.d/fpco.list

apt-get update
apt-get install stack cmake zlib1g-dev oracle-java8-installer atom -y

# git
apt-get install git git-flow -y

SCRIPT

sudo -k

# llvm
mkdir -p ${llvmdir}
cd ${llvmdir}
wget ${giturl}/${bl}
chmod 755 ${bl}
./${bl} ${1}
cd ${llvmdir}/build
echo ${password} | sudo -S make install

# rust
curl -sSf https://static.rust-lang.org/rustup.sh | sh

# stack
cd ${HOME}
stack setup
stack install ghc-mod hlint stylish-haskell hoogle pointfree pointful

# .bashrc
echo 'export PATH=/usr/local/llvm/bin:$PATH' >> ${brc}
echo 'export PATH=$HOME/.local/bin:$PATH' >> ${brc}
echo "alias ghc='stack ghc --'" >> ${brc}
echo "alias ghci='stack ghci --'" >> ${brc}
echo "alias runghc='stack runghc --'" >> ${brc}
echo 'eval "$(stack --bash-completion-script stack)"' >> ${brc}
source ${brc}

# apm
wget ${giturl}/${pk}
chmod 755 ${pk}
./${pk}
