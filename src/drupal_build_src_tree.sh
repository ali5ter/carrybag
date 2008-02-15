#!/bin/bash
# @file
# Check out a version of Drupal core direct from CVS:
# $BASE/drupal/
#              core/
#                      DRUPAL-5, etc.
#              contrib/
#                      DRUPAL-5, etc.
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
	
	for section in core contrib; do
		
		mkdir -p $BASE/drupal/$section/$branch;
		
		case $section in
			core)
				cd $BASE/drupal/core;
				drupal_co.sh $version;
				;;
			contrib)
				cd $BASE/drupal/contrib/$branch;
				drupal_contrib_init.sh $version;
				;;
		esac;
	done;
done;

cd $_PWD;

exit 0;
