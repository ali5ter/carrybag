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

While CarryBag has been used on many versions of OSX, Unix and Linux over the 
years, it is currently used (tried and tested) on the following operating 
systems:
* OSX 10.10 (Yosemite)
* OSX 10.11 (El Capitan)
* Ubuntu 14.04 LTS (Trusty Tahr)
* Ubuntu 15.04 (Vivid Vervet)                                                   
* Ubuntu 15.10 (Wily Werewolf)

## Install
Clone this repository and run `tools/install.sh`.

The fist time it is run, the installation script will ask various questions. I'd 
recommend you answer yes (pressing the y key) to these questions to achieve a 
complete installation.

Running the script after installing will only reset the Bash-it themes, aliases, 
completions and plugins provided by CarryBag. This might be useful if you want 
to revert any changes you might have made to these under `~/.bash-it`

If you want to force the installation script to ask questions then run 
`tools/install.sh --interactive`.

## Managing functionality
The `bash-it` command is used to enable and disable shell functionality. Refer
to the [Bash-it](https://github.com/revans/bash-it) project for more 
information.

Modifications to functionality are typically achieved by adding custom files 
under `~/.bash-it`. Refer to the [Bash-it](https://github.com/revans/bash-it) 
project for more information. Of course, there is nothing stopping you from 
changing anything in the Bash runcom (`.bashrc`, `.bash_profile`) or any file 
under `~/.bash-it`, and re-source'ing the bash shell using `sourcep`... just do 
it at your own risk.

The *carrybag-general* alias and plugin creates a convenience command, 
`housekeeping`, that performs some platform specific updates. It  attempts to 
clean up any OS cruft and keep system and package files up to date.

## Development
If you want to persist any modifications, then you will probably need to 
change the source code in this cloned repository. You can run a full 
installation again to include these updates using `tools/install.sh`. Run 
`tools/install.sh -h` to see other installation options.

The *carrybag-general* alias and plugin creates a convenience command, 
`bootstrap`, to run the installation script in non-interactive, update mode. 
The *carrybag-general* plugin provides a file tool called `mondir` which can be 
used to monitor any changes you make under a directory, like this cloned 
repository, and then run a given command. So you might find it useful to set 
aside one terminal running `mondir 10 "bootstrap && sourcep"` in the repository 
root directory while editing the repository source in another terminal.

The *carrybag-general* plugin also comes with a convenience function, 
`cb_3rdparty_update`, which updates the 3rd party submodules that come with 
CarryBag. Run this at your own risk.

## Contribution
If you've stumbled upon this project and wish to contribute, please 
[let me know](mailto:alister@different.com).