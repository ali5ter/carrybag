#!/bin/bash
# @file
# CVS Update the drupal build tree
# @author Alister Lewis-Bowen (alister@different.com)

export PATH=$PATH:`dirname $0`/../lib; 

BASE=${1:-`pwd`};

_PWD=`PWD`;

function help {
	echo;
	echo "Usage: $(color bd)drupal_update_all.sh$(color off) [$(color bd)target_dir$(color off)]";
	echo "where $(color bd)target_dir$(color off) is the dir into which the tree is build (default is current dir)";
	echo;
	exit 1;
}

if [[ "$BASE" = '-h' || "$BASE" = '--help' ]]; then help; fi;_PWD=`PWD`;

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
				if [ -e $BASE/core/$branch ]; then 
					cd $BASE/core/$branch;
					echo -n "$(color bd)Updating $(color white blue)$(color bd)core/$branch$(color off) $(color bd)from Drupal Contrib CVS...$(color off)";
					cvs update -d -P >/tmp/`basename $0`.log 2>&1;
					echo " $(color green)Done$(color off)";
				fi;
				;;
			modules)
				if [ -e $BASE/contrib/$section/$branch ]; then
					cd $BASE/contrib/$section/$branch;
					echo "$(color bd)Looking in $(color white blue)$(color bd)contrib/$section/$branch$(color off) $(color bd)of Drupal build tree...$(color off)";
					drupal_module_update.sh;
				fi;
				;;
			themes)
				if [ -e $BASE/contrib/$section/$branch ]; then
					cd $BASE/contrib/$section/$branch;
					echo "$(color bd)Looking in $(color white blue)$(color bd)contrib/$section/$branch$(color off) $(color bd)of Drupal build tree...$(color off)";
					drupal_theme_update.sh;
				fi;
				;;
		esac;
	done;
done;

cd $_PWD;

exit 0;
