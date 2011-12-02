#!/bin/bash
# @file
# CVS Update any Drupal theme projects in current directory
# @see color
# @author Alister Lewis-Bowen (alister@different.com)

_PWD=`pwd`;

echo -n "$(color bd)Updating $(color white blue)$(color bd)themes$(color off) $(color bd) from Drupal Contrib CVS...";

for project in `find . -maxdepth 2 -name "page.tpl.php" | cut -d"/" -f 2 | sort | uniq`; do
	cd $_PWD/$project; 
	echo -n ".";
	cvs update -d -P >/tmp/`basename $0`.log 2>&1;
done;

echo " $(color green)Done$(color off)";

cd $_PWD;

exit 0;

