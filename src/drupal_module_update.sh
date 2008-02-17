#!/bin/bash
# @file
# CVS Update any Drupal module projects in current directory
# Usage: drupal_module_update
# @author Alister Lewis-Bowen (alister@different.com)

DIRS=`find -E . -maxdepth 2 -iregex ".*module" | cut -d"/" -f 2 | sort | uniq`;
_PWD=`pwd`;

for dir in $DIRS; do
	cd $_PWD/$dir; 
	cvs update -d -P;
done

cd $_PWD;

echo "Done";

exit 0;

