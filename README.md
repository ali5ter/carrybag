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
Clone this repository and run `tools/install.sh`.

The fist time it is run, the installation script will ask various questions. I'd 
recommend you answer yes (pressing the y key) to these questions to achieve a 
complete installation.

Running the script again after installation will only reset the Bash-it themes, 
aliases, completions and plugins provided by CarryBag. This might be useful if 
you want to revert any changes you might have under `~/.bash-it`

If you want to force the install script to ask you those questions again run 
`tools/install.sh --interactive`.

## Managing functionality
Use the `bash-it` command just as you would for 
[Bash-it](https://github.com/revans/bash-it), e.g. `bash-it help plugins` or 
`bash-it show aliases`

You can add your own customizations to the Bash-it framework using the custom 
files as described in the [Bash-it documentation](https://github.com/revans/bash-it).

Obviously there's nothing stopping you from changing anything in the Bash 
runcom (`.bashrc`, `.bash_profile`) or any file under `~/.bash-it`, and 
resourceing the bash shell using `sourcep`. Just do it at your own risk.

The *carrybag-general* alias and plugin creates a convenience alias, 
`housekeeping`, that performs some platform specific housekeeping. This 
attempts to clean up any OS cruft and keep system and package files up to date.

## Development
If you want to persist any customizations, then you will probably need to 
change the source code in this cloned repository. You can run a full 
installation again using `tools/install.sh`. Run `tools/install.sh -h` to see 
other installation options.

A convenience alias, `bootstrap`, is provided to run the installation script in 
non-interactive, update mode. The *carrybag-general* plugin provides a file 
tool called `mondir` which can be used to monitor any changes you make under 
a directory, like this cloned repository, and then run a given command. So 
you might find it useful to set aside one terminal running 
`mondir 10 "bootstrap && sourcep"` in the repository root directory while 
editing the repository source in another terminal.

The *carrybag-general* plugin also comes with a convenience function, 
`cb_3rdparty_update`, which updates any 3rd party submodules that come with 
CarryBag. Run this at your own risk.

If you've stumbled upon this project and wish to contribute, please 
[let me know](mailto:alister@different.com).
