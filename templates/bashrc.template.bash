#!/usr/bin/env bash

# The template rc copied into place that can be edited by the user

# Path of the CarryBag directory
export CB=~/.carrybag

# Chosen CarryBag theme found in $CB/themes
export CB_THEME='alister'

# Preferred editors
export EDITOR='/usr/bin/vim'
export GIT_EDITOR=$EDITOR

# Initialize CarryBag
source "$CB/carrybag.sh"
