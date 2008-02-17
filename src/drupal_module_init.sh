#/bin/sh
# @file
# Check out a set of Drupal module projects direct from CVS in the current dir
# Usage: drupal_contrib_init [core_version]
# where core_version is 4, 5, 6 or HEAD (default)
#       version is an integer, defaulting to 1
# Modules are listed by project name, one per line, in drupal_contrib_module.list
# @author Alister Lewis-Bowen (alister@different.com)

BRANCH=${1:-HEAD}; # default to HEAD

MODULE_LIST=`dirname $0`/../etc/drupal_contrib_module.list

for module in `cat $MODULE_LIST`; do
	
	drupal_module_co.sh $module $BRANCH;
done;

exit 0;


