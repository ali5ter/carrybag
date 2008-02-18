#!/bin/bash
# @file
# CVS Update any Drupal module projects in current directory
# @author Alister Lewis-Bowen (alister@different.com)

export PATH=$PATH:`dirname $0`/../lib; 

_PWD=`pwd`;
	
echo -n "$(color bd)Updating $(color white blue)$(color bd)modules$(color off) $(color bd)from Drupal Contrib CVS...$(color off)";

for project in `find -E . -maxdepth 2 -iregex ".*module" | cut -d"/" -f 2 | sort | uniq`; do
	cd $_PWD/$project;
	echo -n ".";
	cvs update -d -P >/tmp/`basename $0`.log 2>&1;
done;

echo " $(color green)Done$(color off)";

cd $_PWD;

exit 0;

