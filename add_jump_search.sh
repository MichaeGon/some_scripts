#! /bin/sh

cat << 'EOF' >> ${HOME}/.zshrc

# peco and z
# select destination dir
source $HOME/.z.d/z.sh
function peco-z-search {
    which peco z > /dev/null
    if [ $? -ne 0 ]; then
        git clone https://github.com/rupa/z ${HOME}/.z.d
        brew install peco
        source ${HOME}/.zshrc
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
EOF

source ${HOME}/.zshrc
