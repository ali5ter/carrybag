# CarryBag

**CarryBag** is a collection of my dot files, custom functions and theme settings used to create a bash shell environment I can carry from machine to machine.

This version uses the [Bash-it](https://github.com/revans/bash-it) framework to manage the functionality of aliases, auto-completion, custom functions and themes.

Any external packages used for CarryBag are contained as git submodules in the `3rdparty` directory so I can keep things up-to-date.

**CarryBag** is has been used on various versions of OSX from Mountain Lion to Yosemite and modern versions of Centos and Ubuntu.

## Install

Clone this repository and run `tools/install.sh`

It is recommended that you answer yes to the configuration questions the first time you run the installer. Any edits to the source tree can be installed using the `cb_bootstrap` command.

## Managing functionality

Use the `bash-it` command just as you would for [Bash-it](https://github.com/revans/bash-it), e.g. `bash-it help plugins` or `bash-it show aliases`
