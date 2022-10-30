#Allows running "config" as a way to always refer to my dotfiles git instance globally
#Also defines a git alias which can be used to update my dotfiles to the latest version
alias config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME -c status.showUntrackedFiles=no -c submodule.recurse=true -c alias.update="'"!bash '"$HOME"'/.config/dotfiles/update_dotfiles.sh"'
alias cfg="config"

alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep="fgrep --color=auto"

alias diff="diff --color"

#replace ls with exa
alias ls='exa'
alias l='ls --color=auto --group-directories-first --classify'
alias ll='ls --color=auto --group-directories-first --classify -l'
alias lla='ls --color=auto --group-directories-first --classify -la'

#preserves the settings of the current user
#nvim for example uses the current user's settings instead of the root users
alias sudo="sudo -E"

#Easier to remember/type
alias dc="docker-compose"
alias lad="lazydocker"
alias v="nvim"
alias vim="nvim"
alias g="git"
alias open="xdg-open"
alias bctl="bluetoothctl"
alias sl='ls'
alias startx='ssh-agent startx'
alias upd='sudo pacman -Syu && echo 1 | aur sync -u'
alias up='upd'
alias q='exit'
alias :q='exit'
alias ddl='noglob aria2c -s 16 -x16'
#alias rebootwin='systemctl reboot --boot-loader-entry=auto-windows'

#More verbose output of common commands
alias cp='cp -iv'
alias rcp='rsync -v --progress'
alias rmv='rsync -v --progress --remove-source-files'
alias mv='mv -iv'
alias rm='rm -iv'
alias rmdir='rmdir -v'
alias ln='ln -v'
alias chmod="chmod -c"
alias chown="chown -c"
alias mkdir="mkdir -v"

# fasd aliases https://github.com/clvv/fasd
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
#alias z='fasd_cd -d'     # cd, same functionality as j in autojump
#alias j='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

alias cal="cal -3 --monday --week --color=always"
