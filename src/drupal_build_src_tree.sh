#!/bin/bash
# @file
# Check out a version of Drupal core direct from CVS:
# $BASE/drupal/
#              core/
#                      DRUPAL-5, etc.
#              contrib/
#                      modules/
#                              DRUPAL-5, etc.
# @author Alister Lewis-Bowen (alister@different.com)

export PATH=$PATH:`dirname $0`/../lib; 

BASE=${1:-`pwd`};

_PWD=`PWD`;

function help {
	echo;
	echo "Usage: $(color bd)drupal_build_src_tree.sh$(color off) [$(color bd)target_dir$(color off)]";
	echo "where $(color bd)target_dir$(color off) is the dir into which the tree is build (default is current dir)";
	echo;
	exit 1;
}

if [[ "$BASE" = '-h' || "$BASE" = '--help' ]]; then help; fi;

for version in 4 5 6 HEAD; do
	
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
	
	for section in core modules themes; do
		
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
