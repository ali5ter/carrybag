#!/bin/bash
# @file
# Check out a version of Drupal core direct from CVS:
# $BASE/drupal/
#              core/
#                      DRUPAL-5, etc.
#              contrib/
#                      modules/
#                              DRUPAL-5, etc.
# Usage: drupal_build_src_tree [target_dir]
# @author Alister Lewis-Bowen (alister@different.com)

_PWD=`PWD`;

BASE=${1:-`pwd`};

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
	
	for section in core modules; do
		
		case $section in
			core)
				mkdir -p $BASE/drupal/$section/$branch;
				cd $BASE/drupal/core;
				drupal_co.sh $version;
				;;
			modules)
				mkdir -p $BASE/drupal/contrib/$section/$branch;
				cd $BASE/drupal/contrib/$section/$branch;
				drupal_module_init.sh $version;
				;;
			themes)
				mkdir -p $BASE/drupal/contrib/$section/$branch;
				cd $BASE/drupal/contrib/$section/$branch;
				drupal_theme_init.sh $version;
				;;
		esac;
	done;
done;

cd $_PWD;

exit 0;
