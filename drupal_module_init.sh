#!/bin/bash
# @file
# Check out a set of Drupal module projects direct from CVS in the current dir
# Modules are listed by project name, one per line, in drupal_contrib_module.list
# @see color
# @author Alister Lewis-Bowen (alister@different.com)

BRANCH=$1;

MODULE_LIST=`dirname $0`/../etc/drupal_contrib_module.list

function help {
	echo;
	echo "Usage: $(color bd)drupal_module_init.sh$(color off) [$(color bd)version$(color off)]";
	echo "where $(color bd)version$(color off) is 4, 5, 6, or HEAD (default)";
	echo;
	exit 1;
}

if [[ "$BRANCH" = '-h' || "$BRANCH" = '--help' ]]; then help; fi;
	
for module in `cat $MODULE_LIST`; do
	drupal_module_co.sh $module $BRANCH;
done;

exit 0;


