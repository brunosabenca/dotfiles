# If not running interactively, don't do anything
[[ $- != *i* ]] && return

src() {
  [ -f "$1" ] && source "$1"
}

# plugins/ssh-agent configuration
zstyle :omz:plugins:ssh-agent identities id_fourforty id_ed25519 id_rsa id_openshift

# Completion
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle :compinstall filename "${HOME}/.zshrc"
autoload -Uz compinit
#compinit

ZSH_THEME="dracula"

# zgen
ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc ${HOME}/.zshrc.local)

# Load zgen only if a user types a zgen command
zgen () {
  if [[ ! -s ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh ]]; then
    git clone --recursive https://github.com/tarjoilija/zgen.git ${ZDOTDIR:-${HOME}}/.zgen
  fi
  source ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh
  zgen "$@"
}

if [[ ! -s ${ZDOTDIR:-${HOME}}/.zgen/init.zsh ]]; then
  echo "Creating a zgen save..."
  # plugins
  #zgen oh-my-zsh plugins/thefuck
  #zgen oh-my-zsh plugins/ssh-agent
  zgen load changyuheng/zsh-interactive-cd
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search
  zgen load dracula/zsh

  # completions
  zgen load zsh-users/zsh-completions src

  # save all to init script
  zgen save

  zcompile ${ZDOTDIR:-${HOME}}/.zgen/init.zsh
else
  source ${ZDOTDIR:-${HOME}}/.zgen/init.zsh
fi

# fasd - https://github.com/clvv/fasd
eval "$(fasd --init auto)"

# marker - https://github.com/pindexis/marker
#[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"

# z - fasd & fzf change directory
# jump using `fasd` if given argument,
# filter output of `fasd` using `fzf` else
unalias z
z() {
    [ $# -gt 0 ] && fasd_cd -d "$*" && return
    local dir
    dir="$(fasd -Rdl "$1" | fzf-tmux -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}
alias j=z

# v - open files in ~/.viminfo
v() {
  local files
  files=$(grep '^>' ~/.viminfo | cut -c3- |
          while read line; do
            [ -f "${line/\~/$HOME}" ] && echo "$line"
          done | fzf-tmux -d -m -q "$*" -1) && vim ${files//\~/$HOME}
}

# c - browse chrome history
c() {
  local cols sep google_history open
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  google_history="$HOME/.config/google-chrome/Default/History"
  open=xdg-open

  cp -f "$google_history" /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
}

# Settings
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

# Bindings
bindkey -v
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

bindkey -M vicmd '?' history-incremental-search-backward
bindkey '^r' history-incremental-search-backward

bindkey "^P" vi-up-line-or-history
bindkey "^N" vi-down-line-or-history
#bindkey '^P' up-history
#bindkey '^N' down-history

bindkey "^[[1~" vi-beginning-of-line   # Home
bindkey "^[[4~" vi-end-of-line         # End
bindkey '^[[2~' beep                   # Insert
bindkey '^[[3~' delete-char            # Del
bindkey '^[[5~' vi-backward-blank-word # Page Up
bindkey '^[[6~' vi-forward-blank-word  # Page Down

bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

bindkey '^w' backward-kill-word

# Prompt
autoload -Uz promptinit
promptinit
#prompt pure
#PROMPT='%(?.%F{magenta}△.%F{red}▲)%f '
prompt grml


# Text Objects
autoload -U select-bracketed
autoload -U select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in visual viopp; do
    bindkey -M $km -- '-' vi-up-line-or-history
    for c in {a,i}${(s..)^:-\'\"\`\|,./:;-=+@}; do
        bindkey -M $km $c select-quoted
    done
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M $km $c select-bracketed
    done
done

autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround


# Apply matching to completion results

# below is same as the zsh default effect
# zstyle ':completion:*::::' completer _complete _ignored
zstyle ':completion:*::::' completer _complete _match _ignored


# Remap expand-or-complete from <Tab> to <C-x><Tab>
bindkey '^I' complete-word
bindkey '^X^I' expand-or-complete

# Enable insertion of all completion matches into the command line
# by pressing C-x, C-a
zle -C all-matches complete-word _my_generic
zstyle ':completion:all-matches::::' completer _all_matches
zstyle ':completion:all-matches:*' old-matches only
_my_generic () {
  local ZSH_TRACE_GENERIC_WIDGET=  # works with "setopt nounset"
  _generic "$@"
}
bindkey '^X^a' all-matches


# Clipboard Integration
[[ -n $DISPLAY ]] && (( $+commands[xclip] )) && {

    function cutbuffer() {
        zle .$WIDGET
        echo $CUTBUFFER | xclip
    }

    zle_cut_widgets=(
        vi-backward-delete-char
        vi-change
        vi-change-eol
        vi-change-whole-line
        vi-delete
        vi-delete-char
        vi-kill-eol
        vi-substitute
        vi-yank
        vi-yank-eol
    )
    for widget in $zle_cut_widgets
    do
        zle -N $widget cutbuffer
    done

    function putbuffer() {
        zle copy-region-as-kill "$(xclip -o)"
        zle .$WIDGET
    }

    zle_put_widgets=(
        vi-put-after
        vi-put-before
    )
    for widget in $zle_put_widgets
    do
        zle -N $widget putbuffer
    done
}

# fzf - https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_DEFAULT_OPTS='--height 50%'
export FZF_TMUX=1
export FZF_TMUX_HEIGHT=50%

# Include other files
source ~/.zsh/setopt.zsh
source ~/.profile

source ~/.bash_aliases

# Expand alias on enter
expand_alias_enter() {
    zle _expand_alias
    zle accept-line
}

# Expand alias on space
expand_alias_space() {
    zle _expand_alias
    zle self-insert
}

# Create widgets
zle -N expand_alias_enter
zle -N expand_alias_space

# Bind keys
bindkey '^M' expand_alias_enter
bindkey ' ' expand_alias_space

secret() {
	output="${HOME}/$(basename ${1}).$(date +%F).enc"
	gpg --encrypt --armor \
		--output ${output} \
		-r 0xDBEAEF353D53D772 \
		-r bruno@brunosabenca.com \
		"${1}" && echo "${1} -> ${output}" }
reveal() {
	output=$(echo "${1}" | rev | cut -c16- | rev)
	gpg --decrypt --output ${output} "${1}" \
		&& echo "${1} -> ${output}" }
