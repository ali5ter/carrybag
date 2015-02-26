```
  ██████╗ █████╗ ██████╗ ██████╗ ██╗   ██╗██████╗  █████╗  ██████╗
 ██╔════╝██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝██╔══██╗██╔══██╗██╔════╝
 ██║     ███████║██████╔╝██████╔╝ ╚████╔╝ ██████╔╝███████║██║  ███╗
 ██║     ██╔══██║██╔══██╗██╔══██╗  ╚██╔╝  ██╔══██╗██╔══██║██║   ██║
 ╚██████╗██║  ██║██║  ██║██║  ██║   ██║   ██████╔╝██║  ██║╚██████╔╝
  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝ ╚═════╝
```
# CarryBag v2
**CarryBag** is my collection of dot files, custom functions and theme settings 
used to create a bash shell environment I can carry from machine to machine.

This version uses the [Bash-it](https://github.com/revans/bash-it) framework to 
manage the functionality of aliases, auto-completion, custom functions and themes.

External packages used by CarryBag are loaded as git submodules in the 
`3rdparty` directory to make it easier to keep things up-to-date.

While CarryBag has been used on many versions of OSX, Unix and Linux, it is 
currently used on the following operating systems:
* OSX 10.10 (Yosemite)
* Ubuntu 14.04 LTS (Trusty Tahr)

## Install
Clone this repository and run `tools/install.sh`

The fist time it is run, the installation script will ask various questions. I'd
recommend you answer yes to these questions to achieve a complete installation. 
The script can be run again if you need to incorporate any changes to the 
installation. If you want to force interaction, use the `-i` or `--interaction` 
option with the installation script.

A convenience alias, `bootstrap`, is provided to run the installation script in
non-interactive mode.

CarryBag comes with a platform specific housekeeping script called using the 
`housekeeping` command. This attempts to clean up any OS cruft and keep system 
and package files up to date.

You can update any 3rd party packages that come with CarryBag (at your own 
risk) by running `cb_3rdparty_update`.

## Managing functionality
Use the `bash-it` command just as you would for 
[Bash-it](https://github.com/revans/bash-it), e.g. `bash-it help plugins` or 
`bash-it show aliases`
