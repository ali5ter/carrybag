#!/usr/bin/env bash
# Uninstall CarryBag

set -e

## Remove any CarryBag v1 symlinks from $HOME
find "$HOME" -maxdepth 1 -type l -ilname "*carrybag*" -print0 | xargs -0 rm -fR
find "$HOME/bin" -maxdepth 1 -type l -ilname "*carrybag*" -print0 | xargs -0 rm -fR

## Restore backed up bash runcom file
case "$OSTYPE" in
    darwin*)    BASHRC=~/.bash_profile ;;
    *)          BASHRC=~/.bashrc ;;
esac
[ -w "$BASHRC.bak" ] && cp "$BASHRC.bak" "$BASHRC"
[ -e $BASHRC ] || {
    case "$OSTYPE" in
        darwin*)    cp /etc/bashrc "$BASHRC" ;;
        *)          cp /etc/skel/.bashrc "$BASHRC" ;;
    esac
}

## Restore other files the installer may have backed up
for file in ~/.vim ~/.vimrc ~/.Xdefaults ~/.Xresources; do
    [ -w "$file.bak" ] && cp -r "$file.bak" "$file"
done;

source "$BASHRC"
