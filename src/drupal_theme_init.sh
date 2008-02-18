#!/bin/bash
# @file
# Check out a set of Drupal module projects direct from CVS in the current dir
# Usage: drupal_contrib_init [core_version]
# where core_version is 4, 5, 6 or HEAD (default)
#       version is an integer, defaulting to 1
# Modules are listed by project name, one per line, in drupal_contrib_module.list
# @author Alister Lewis-Bowen (alister@different.com)

BRANCH=$1;

THEME_LIST=`dirname $0`/../etc/drupal_contrib_theme.list

function help {
	echo;
	echo "Usage: $(color bd)drupal_theme_init.sh$(color off) [$(color bd)version$(color off)]";
	echo "where $(color bd)version$(color off) is 4, 5, 6, or HEAD (default)";
	echo;
	exit 1;
}

if [[ "$BRANCH" = '-h' || "$BRANCH" = '--help' ]]; then help; fi;
	
for module in `cat $THEME_LIST`; do
	drupal_theme_co.sh $module $BRANCH;
done;

exit 0;

