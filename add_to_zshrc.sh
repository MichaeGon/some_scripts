#! /bin/sh

# install
# z
git clone https://github.com/rupa/z ${HOME}/.z.d

mkdir -p ${HOME}/.zsh
git clone https://github.com/Tarrasch/zsh-bd.git ${HOME}/.zsh/bd
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.zsh/highlight

cat << 'EOF' >> ${HOME}/.zshrc

# peco and z
# select destination dir
source $HOME/.z.d/z.sh
function peco-z-search {
    which peco > /dev/null
    if [ $? -ne 0 ]; then
        echo "not found peco"
        exit 1
    fi

    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi

    local dest=$(_z -r 2>&1 | eval ${tac} | peco --query "${LBUFFER}" | awk '{ print $2 }')
    if [ -n "${dest}" ]; then
        cd ${dest}
    fi

    zle reset-prompt
}

zle -N peco-z-search
bindkey '^f' peco-z-search

function peco-cmd-history {
    BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-cmd-history
bindkey '^r' peco-cmd-history

# git checkout
function peco-git-checkout {
    local res
    local branch=$(git branch -a | peco | tr -d ' ')
    if [ -n "$branch" ]; then
        if [[ "$branch" =~ "remotes/" ]]; then
            local b=$(echo branch | awk -F'/' '{print $3}')
            res="git checkout -b '${b}' '${branch}'"
        else
            res="git checkout ${branch}"
        fi
    fi
    BUFFER=${res}
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-git-checkout
bindkey '^g' peco-git-checkout

# bd
source ${HOME}/.zsh/bd/bd.zsh

# zsh-syntax-highlighting
source ${HOME}/.zsh/highlight/zsh-syntax-highlighting.zsh

EOF
