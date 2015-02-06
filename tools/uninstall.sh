#!/usr/bin/env bash
# Uninstall CarryBag

set -e

## Remove any CarryBag symlinks from $HOME (good for version 1 cruft too)
find "$HOME" -maxdepth 1 -type l -ilname "*carrybag*" | xargs rm -fR

## Restore backed up bash runcom file
case "$OSTYPE" in
    darwin*)    BASHRC=~/.bash_profile ;;
    *)          BASHRC=~/.bashrc ;;
esac
[ -w "$BASHRC.bak" ] && cp "$BASHRC.bak" "$BASHRC"
[ ! -e $BASHRC ] && BASHRC=/etc/bashrc

## Restore other files the installer may have backed up
for file in ~/.vim ~/.vimrc ~/.Xdefaults ~/.Xresources; do
    [ -w "$file.bak" ] && cp "$file.bak" "$file"
done;

source "$BASHRC"
