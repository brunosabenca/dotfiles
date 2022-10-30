#!/bin/sh

# This installs my dotfiles in the current users home dir
# This is only supposed to be run once. It's supposed to be fetched with curl, for example. The executable flag is therefor turned off.
# Then remove the "exit 1" to use it

exit 1

#How it works...
#All we care about is the .git folder which is placed in ~/.dotfiles and then a git reset --hard is used to place the contents of the repo in the HOME dir.
#git reponds with error if you try to clone a repos content directly into a directory which already has content. This circumvents that.

cd ~ && \
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/brunosabenca/dotfiles $HOME/dotfiles-tmp

#We define the function "config" here
source $HOME/dotfiles-tmp/bin/scripts/functions.sh

#places base files in their correct position
config reset --hard

#clean up
rm -rf $HOME/dotfiles-tmp

#Fetch submodules
config update && \
echo "Successfully setup dotfiles! Open a new shell to finalize!"

