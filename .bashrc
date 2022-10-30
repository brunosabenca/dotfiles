#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.profile

alias ls='ls --color=auto'
alias :q='exit'
alias netbeans='netbeans -J-Dswing.aatext=true -J-Dawt.useSystemAAFontSettings=on'
alias verynice='ionice -c3 nice -n 15'

alias e='emacsclient'
alias ec="emacsclient -c -n -a ''"

alias E="SUDO_EDITOR=\"emacsclient -c -a ''\" sudoedit"


PS1='[\u@\h \W]\$ '

eval $(dircolors ~/.dircolors)

eval $(keychain --eval --quiet id_rsa id_ed25519)

function secure_chromium {
    port=4711
    export SOCKS_SERVER=localhost:$port
    export SOCKS_VERSION=5
    chromium &
    exit
}

alias isec="ssh -TND 4711 serenity && secure_chromium"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export http_proxy=''
export https_proxy=''
export ftp_proxy=''
export socks_proxy=''
