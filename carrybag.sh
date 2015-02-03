#!/usr/bin/env bash

# The initilization of Carrybag

# @usage reload ... reload the bash runcom
reload() {
    case "$OSTYPE" in
        darwin*)    source ~/.bash_profile;;
        *)          source ~/.bashrc;;
    esac
}
