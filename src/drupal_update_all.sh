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
				mkdir -p $BASE/drupal/$section/$branch;
				cd $BASE/drupal/core;
				cvs update -d -P;
				;;
			modules)
				mkdir -p $BASE/drupal/contrib/$section/$branch;
				cd $BASE/drupal/contrib/$section/$branch;
				drupal_contrib_update.sh;
				;;
			themes)
				mkdir -p $BASE/drupal/contrib/$section/$branch;
				cd $BASE/drupal/contrib/$section/$branch;
				drupal_theme_update.sh;
				;;
		esac;
	done;
done;

cd $_PWD;

exit 0;
