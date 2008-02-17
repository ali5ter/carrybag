#/bin/sh
# @file
# Parse the HEAD module info files to figure what's what
# WORK IN PROGRESS
# Usage: drupal_module_info
# @author Alister Lewis-Bowen (alister@different.com)
# @todo Figure out the info file format so this works!

BASE=/Users/abowen/Development/drupal/modules;
_PWD=`pwd`;
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

cd $_PWD;

exit 0;

