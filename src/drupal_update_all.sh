#!/bin/bash
# @file
# CVS Update the drupal build tree
# Usage: drupal_update_all [target_dir]
# @author Alister Lewis-Bowen (alister@different.com)

_PWD=`PWD`;

BASE=${1:-`pwd`};

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
				cd $BASE/drupal/core/$branch;
				cvs update -d -P;
				;;
			modules)
				cd $BASE/drupal/contrib/$section/$branch;
				drupal_module_update.sh;
				;;
			themes)
				cd $BASE/drupal/contrib/$section/$branch;
				drupal_theme_update.sh;
				;;
		esac;
	done;
done;

cd $_PWD;

exit 0;
