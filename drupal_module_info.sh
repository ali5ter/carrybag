#!/bin/bash
# @file
# Parse the HEAD module info files (http://drupal.org/node/101009)
# to figure what's what. ANSI colors are creating using 'color' 
# (http://freshmeat.net/projects/color/).
# Usage: drupal_module_info
# @see color
# @author Alister Lewis-Bowen (alister@different.com)

_PWD=`pwd`;
BASE=~/Development/drupal/contrib/modules;
TARGET_DIR=HEAD;
cd $BASE/$TARGET_DIR;

heading='           Project module name       Project package  Core';
#        ------------------------------  --------------------  ----
echo "$(color ul)$heading$(color off)";

for project in `find . -name "*.info" | sort `; do
	
	name=`find $project | xargs egrep -i 'name.*=' | cut -d'=' -f2 | cut -d'"' -f2 `;
	name=${name:---};
	
	package=`find $project | xargs egrep -i 'package.*=' | cut -d'=' -f2 | cut -d'"' -f2`;
	package=${package:---};
	
	# Introduced in D6...
	core=`find $project | xargs egrep -i 'core.*=' | cut -d' ' -f3 | cut -d'"' -f2 `;
	core=${core:-5.x};
	
	# not used now when checking out from CVS...
	#version=`find $project | xargs egrep -i 'version.*=' | cut -d' ' -f3 | cut -d'"' -f2 | uniq`;
	
	if [ $core = '5.x' ]; then
		color='green';
	else
		color='yellow';
	fi;
	
	printf "$(color $color)%30s  %20s  %4s$(color off)" "$name" "$package" "$core";
	#printf "  %s" $project; # for debug purposes
	printf "\n";
done;

cd $_PWD;

exit 0;

