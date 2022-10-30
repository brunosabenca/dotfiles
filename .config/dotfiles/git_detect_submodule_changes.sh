#!/bin/bash

# Used to get "config" function
source ~/bin/scripts/functions.sh

config submodule foreach git checkout master
config submodule foreach git remote update

echo "----------------------------------"

config submodule foreach git status -uno
