#!/bin/bash
# ----------------------------------------------------------------------------
# @file
# CVS Update the drupal build tree
# @see color
# @author Alister Lewis-Bowen (alister@different.com)
# ----------------------------------------------------------------------------

BASE=${1:-`pwd`};
_PWD=`PWD`;
LOG=/tmp/`basename $0`.log;

# Function: Help
# ----------------------------------------------------------------------------

function help {
	echo;
	echo "Usage: $(color bd)drupal_update_all.sh$(color) [$(color ul)target_dir$(color)]";
	echo "where $(color ul)target_dir$(color) is the dir into which the tree is build (default is current dir)";
	echo;
	exit 1;
}

# Update the existing tree
# ----------------------------------------------------------------------------

if [[ "$BASE" = '-h' || "$BASE" = '--help' ]]; then help; fi;_PWD=`PWD`;

for version in 5 6 HEAD; do
	
	case $version in
		4)
			branch=DRUPAL-4-7;
			;;
		5)
			branch=DRUPAL-5;
			;;
		6)
			branch=DRUPAL-6;
			;;
		*)
			branch=HEAD;
			;;
	esac;
	
		for section in core modules; do
		
		case $section in
			core)
				if [ -e $BASE/core/$branch ]; then 
					cd $BASE/core/$branch;
					echo -en "Drupal core:\t";
					cvs -Q up -d -P 2>$LOG;
					echo " $(color green)Done$(color)";
				fi;
				;;
			modules)
				if [ -e $BASE/contrib/$section/$branch ]; then
					cd $BASE/contrib/$section/$branch;
					drupal_module_update.sh;
				fi;
				;;
			themes)
				if [ -e $BASE/contrib/$section/$branch ]; then
					cd $BASE/contrib/$section/$branch;
					drupal_theme_update.sh;
				fi;
				;;
		esac;
	done;
done;

cd $_PWD;

exit 0;
