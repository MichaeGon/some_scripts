#!/bin/sh

if [ $# -lt 1 ] ; then
    echo "usage: ./ubuntu_setup.sh <llvm version>"
    exit 1
fi

printf "password:"
read password

codename=`lsb_release -a | grep Codename | awk '{print $2}'`
llvmdir=${HOME}/llvm/build/${1}
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

# git
apt-get install git -y
apt-get install git-flow -y

# gcc
apt-get install gcc g++ -y

# python
apt-get install python -y

# cmake
apt-get install cmake -y

# zlib
apt-get install zlib1g-dev -y

# vim
apt-get install vim -y

# scala
apt-get install scala -y

apt-get install stack -y
apt-get oracle-java8-installer -y
apt-get atom -y

SCRIPT

sudo -k

# llvm
mkdir -p ${llvmdir}
cd ${llvmdir}

page_prefix=http://llvm.org/releases/
tx=.tar.xz
s=.src
stx=${s}${tx}
tool_dir=llvm/tools/
projects_dir=llvm/projects/

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
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr/local/llvm/ ../llvm/
make -j4

cd ${llvmdir}/build
echo ${password} | sudo -S make install

# rust
curl -sSf https://static.rust-lang.org/rustup.sh | sh
cargo install racer
rustsrc=${HOME}/rust
mkdir -p ${rustsrc}
cd ${rustsrc}
wget https://www.rust-lang.org/en-US/
cat index.html | grep https://static.rust-lang.org/dist/rustc | \
awk -F \" '{print $2}' | wget
tar zxvf *.gz
rm *.gz
mv rustc* src

# stack
cd ${HOME}
stack setup
stack install ghc-mod hlint stylish-haskell hoogle pointfree pointful

# .bashrc
echo "export RUST_SRC_PATH=${rustsrc}/src" >> ${brc}
echo 'export PATH=/usr/local/llvm/bin:$PATH' >> ${brc}
echo 'export PATH=$HOME/.local/bin:$PATH' >> ${brc}
echo "alias ghc='stack ghc --'" >> ${brc}
echo "alias ghci='stack ghci --'" >> ${brc}
echo "alias runghc='stack runghc --'" >> ${brc}
echo 'eval "$(stack --bash-completion-script stack)"' >> ${brc}
source ${brc}

# apm
# something
apm install minimap file-icons highlight-column highlight-line color-picker pigments
# git
apm install git-history git-control merge-conflicts git-plus git-log tualo-git-context
# haskell
apm install ide-haskell haskell-ghc-mod ide-haskell-cabal autocomplete-haskell language-haskell haskell-pointfree linter-hlint
# clang
apm install linter-clang autocomplete-clang
# rust
apm install language-rust linter-rust racer
# java
apm install autocomplete-java linter-javac
# scala
apm install language-scala linter-scalac
