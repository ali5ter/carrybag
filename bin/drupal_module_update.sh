#!/bin/bash
# ----------------------------------------------------------------------------
# @file
# CVS Update any Drupal module projects in current directory
# @see color
# @author Alister Lewis-Bowen (alister@different.com)
# ----------------------------------------------------------------------------

BASE=${1:-`pwd`};
_PWD=`pwd`;
LOG=/tmp/`basename $0`.log;

# Function: Help
# ----------------------------------------------------------------------------

function help {
	echo;
	echo "Usage: $(color bd)drupal_moduleupdate.sh$(color) [$(color ul)target_dir$(color)]";
	echo "where $(color ul)target_dir$(color) is the dir in which the modules exits (default is current dir)";
	echo;
	exit 1;
}

if [[ "$BASE" = '-h' || "$BASE" = '--help' ]]; then help; fi;

# Update the existing tree
# ----------------------------------------------------------------------------

echo -n "$(color bd)Updating $(color white blue)$(color bd)modules$(color off) $(color bd)from Drupal Contrib CVS...$(color off)";

for project in `find -E . -maxdepth 2 -iregex ".*module" | cut -d"/" -f 2 | sort | uniq`; do
	cd $BASE/$project;
	echo -en "Updating module:\t$(color white blue) $project $(color)\t";
	cvs -Q up -d -P 2>$LOG;
done;

echo " $(color green)Done$(color)";

cd $_PWD;

exit 0;

