#/bin/sh
# $Id: drupal_contrib_versions,v 1.1 2008/02/15 19:00:14 abowen Exp $

#find ./ -name *.info | xargs egrep 'core.*=.*6' | cut -d'/' -f3|sort|uniq

BASE=/Users/abowen/Development/drupal/contrib;
TARGET_DIR=HEAD;

cd $BASE/$TARGET_DIR;

echo "      Project module name            Project package  Core  Version";
echo "-------------------------  -------------------------  ----  ---------------";
#for project in `find ./ -name *.info | cut -d'/' -f3 | sort | uniq`; do
for project in `find ./ -name *.info | sort `; do
	name=`find $project | xargs egrep -i 'project.*=' | cut -d' ' -f3 | cut -d'"' -f2 | uniq`;
	package=`find $project | xargs egrep -i 'package.*=' | cut -d'=' -f2 | cut -d'"' -f2`;
	core=`find $project | xargs egrep -i 'core.*=' | cut -d' ' -f3 | cut -d'"' -f2 `;
	version=`find $project | xargs egrep -i 'version.*=' | cut -d' ' -f3 | cut -d'"' -f2 | uniq`;
	printf "%25s  %25s  %4s  %15s  %s\n" $name ${package:---} ${core:---} ${version:---} $project;
done;

