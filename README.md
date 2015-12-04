```
  ██████╗ █████╗ ██████╗ ██████╗ ██╗   ██╗██████╗  █████╗  ██████╗
 ██╔════╝██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝██╔══██╗██╔══██╗██╔════╝
 ██║     ███████║██████╔╝██████╔╝ ╚████╔╝ ██████╔╝███████║██║  ███╗
 ██║     ██╔══██║██╔══██╗██╔══██╗  ╚██╔╝  ██╔══██╗██╔══██║██║   ██║
 ╚██████╗██║  ██║██║  ██║██║  ██║   ██║   ██████╔╝██║  ██║╚██████╔╝
  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝ ╚═════╝
```
# CarryBag v2
**CarryBag is my collection of dot files, custom functions and theme settings 
used to create a bash shell environment I can carry from machine to machine.**

This version uses the [Bash-it](https://github.com/revans/bash-it) framework to 
manage the availability of aliases, auto-completion, custom functions and
themes.

External packages used by CarryBag are loaded as git submodules in the 
[3rdparty](3rdparty) directory.

CarryBag has been used on many versions of OSX, Unix and Linux over the 
years. It probably works on most *NIX based system but is currently used on the
following operating systems:
* OSX 10.11 (El Capitan)
* Ubuntu 14.04 LTS (Trusty Tahr)
* Ubuntu 15.04 LTS (Vivid Vervet)

## Installation
Clone this repository and run the installer

	git clone http://gitlab.different.com/alister/carrybag.git
	./tools/install

The fist time the installation is run, the script will provide prompts asking
which parts of the CarryBag environment should be installed. Answering yes
(pressing the **y** key) to all these will create a complete installation.

Running the script after the initial installation will only re-install the
Bash-it themes, aliases, completions and plugins provided by CarryBag.

If you want to force the installation script to provide prompts, run

	./tools/install --interactive

To uninstall CarryBag run

	./tools/uninstall

## Managing functionality
The **bash-it** command is used to discover, enable and disable shell
functionality. 

For example, to display the shell commands provided by the enabled Bash-it
plugins, run

	bash-it help plugins

To show what plugins are enabled out of all the plugins provided, run

	bash-it show plugins

To make the functionality of the **carrybag-math** plugin available, enable it
using

	bash enable plugin carrybag-math

Refer to the [Bash-it](https://github.com/revans/bash-it) project for more 
information.

## Custom functionality
Refer to the [Bash-it](https://github.com/revans/bash-it) project for more
information about how to add custom functions, aliases and themes.

## Housekeeping
The **carrybag-general** alias and plugin creates a convenience command that
performs platform specific housekeeping, such as deletion of log and cache items
and package updates and pruning. Run this periodically using

	housekeeping

## Development
If you want to in include your custom functionality in CarryBag, then you will
need to change the source code.

The **carrybag-general** alias and plugin provides a convenience command to run 
the installation script in a non-interactive, update mode:

	bootstrap

The **carrybag-general** plugin also provides tool to monitor any changes made 
under a directory, like this source code, and then run a given command when any
changes have been detected. You might find it useful to set aside one terminal
running the following command in the repository root directory while editing the
repository source in another terminal.

	mondir 10 "bootstrap && sourcep”

This will reinstall CarryBag and source the changes automatically. Increase the
10 second wait if you are making lots of small changes.

## Updating the 3rd Party dependencies
The **carrybag-general** plugin also comes with a convenience function to update
the 3rd party submodules that come with CarryBag.

	cb_3rdparty_update

Run this at your own risk!

## Contribution
If you've stumbled upon this project and wish to contribute, please 
[let me know](mailto:alister@different.com).