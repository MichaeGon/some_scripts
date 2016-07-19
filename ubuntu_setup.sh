#!/bin/sh

if [ $# -lt 1 ] ; then
    echo "usage: ./ubuntu_setup.sh <llvm version>"
    exit 1
fi

codename=`lsb_release -a | grep Codename | awk '{print $2}'`
llvmdir=${HOME}/llvm/build/${1}
brc=${HOME}/.bashrc

sudo -k

mkdir -p ${llvmdir}

sudo sh <<SCRIPT

for item in atom java
do
    add-apt-repository ppa:webupd8team/${item}
done

# stack
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 575159689BEFB442
echo "deb http://download.fpcomplete.com/ubuntu ${codename} main" | \
tee /etc/apt/sources.list.d/fpco.list

apt-get update

for item in git git-flow gcc g++ python cmake zlib1g-dev vim scala stack oracle-java8-installer atom
do
    apt-get install ${item} -y
done

# llvm
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
make install

SCRIPT


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
for item in ghc ghci runghc
do
    echo "alias ${item}='stack ${item} --'" >> ${brc}
done
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
