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

CarryBag is has been used on many versions of OSX, Unix and Linux. I currently
use it on OSX Yosemite and Ubuntu 12.4.

## Install
Clone this repository and run `tools/install.sh`

The installation script asks various questions. I'd recommend you answer yes to
these questions the first time you run the installer. Any edits to the source 
tree can be installed using the `cb_bootstrap` command.

CarryBag come with a platform specific (OSX and Linux for now) housekeeping
script called `cd_housekeeping` which attempts to keep your system and package 
files up to date.

## Managing functionality
Use the `bash-it` command just as you would for 
[Bash-it](https://github.com/revans/bash-it), e.g. `bash-it help plugins` or 
`bash-it show aliases`
