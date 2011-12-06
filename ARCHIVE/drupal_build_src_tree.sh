#!/bin/bash
# ----------------------------------------------------------------------------
# @file
# Check out a version of Drupal core direct from CVS:
# $BASE/
#       core/
#               DRUPAL-5, etc.
#       contrib/
#               modules/
#                       DRUPAL-5, etc.
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
	echo "Usage: $(color bd)drupal_build_src_tree.sh$(color) [$(color ul)target_dir$(color)]";
	echo "where $(color ul)target_dir$(color) is the dir into which the tree is build (default is current dir)";
	echo;
	exit 1;
}

# Build out the tree
# ----------------------------------------------------------------------------

if [[ "$BASE" = '-h' || "$BASE" = '--help' ]]; then help; fi;

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
				mkdir -p $BASE/$section/$branch;
				cd $BASE/core;
				drupal_co.sh $version;
				;;
			modules)
				mkdir -p $BASE/contrib/$section/$branch;
				cd $BASE/contrib/$section/$branch;
				drupal_module_init.sh $version;
				;;
			themes)
				mkdir -p $BASE/contrib/$section/$branch;
				cd $BASE/contrib/$section/$branch;
				drupal_theme_init.sh $version;
				;;
		esac;
	done;
done;

cd $_PWD;

exit 0;