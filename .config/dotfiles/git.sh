#!/bin/sh

# Run this script to apply git settings

# This makes it so that I only use SSH for my own repos
git config --global url."ssh://git@github.com/brunosabenca/".insteadOf "https://github.com/brunosabenca/"
git config --global user.user "Bruno Sabença"
git config --global user.name "Bruno Sabença"
git config --global user.email "brunosabenca@users.noreply.github.com"
git config --global blame.date 'format:%Y-%m-%d %H:%M:%S'

git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date-order"
git config --global alias.st "status"
git config --global alias.s "status"
git config --global alias.cm "commit -m"
git config --global alias.c "commit -v"
git config --global alias.ca "commit -v -a"
git config --global alias.cam "commit -a -m"
git config --global alias.co "checkout"
git config --global alias.cob '! git checkout $(git branch | fzf)'
git config --global alias.br "branch"
git config --global alias.d "diff"
git config --global alias.p "pull"
git config --global alias.f "fetch"
git config --global alias.sw "switch"
git config --global alias.wip "! git add . && git commit -m 'WIP' && git push"
git config --global alias.authors "shortlog -s -n -e"
git config --global alias.filehist "log -p"
git config --global alias.filerev '! git show'
# git config --global alias.filerev '! GIT_PAGER="nvim -c set ft="$(echo -e "go\npython" | fzf)"" git show'

# find most changed file
# git log --name-status --pretty=format: | sed 's!.*/!!' | grep ".go" | cut --fields=2- | sort | uniq --count | sort --numeric-sort --reverse

git config --global core.editor "nvim"
git config --global core.eol "lf"
git config --global core.autocrlf "input"
git config --global pull.ff only

#difftool
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.features "side-by-side line-numbers decorations"
#git config --global delta.syntax-theme "OneHalfDark"
git config --global delta.whitespace-error-style "22 reverse"
git config --global delta."decorations".commit-decoration-style "bold yellow box ul"
git config --global delta."decorations".file-style "bold yellow ul"
git config --global delta."decorations".file-decoration-style "none"

echo "Updated global git config"
