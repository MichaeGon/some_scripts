#!/bin/sh

codename=`lsb_release -a | grep Codename | awk '{print $2}'`

brc=${HOME}/.bashrc

for item in atom java
do
    sudo add-apt-repository ppa:webupd8team/${item}
done

# stack
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 575159689BEFB442
echo "deb http://download.fpcomplete.com/ubuntu ${codename} main" | \
tee /etc/apt/sources.list.d/fpco.list

sudo apt-get update

sudo apt-get install -y git git-flow gcc g++ python cmake zlib1g-dev vim scala stack oracle-java8-installer atom

# stack
cd ${HOME}
stack setup
stack install ghc-mod hlint stylish-haskell hoogle pointfree pointful

# .bashrc
echo "export RUST_SRC_PATH=${rustsrc}/src" >> ${brc}
echo 'export PATH=/usr/local/llvm/bin:$PATH' >> ${brc}
echo 'export PATH=$HOME/.local/bin:$PATH' >> ${brc}
for item in ghc ghci runghc
do
    echo "alias ${item}='stack ${item} --'" >> ${brc}
done
echo 'eval "$(stack --bash-completion-script stack)"' >> ${brc}
source ${brc}
