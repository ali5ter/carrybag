#!/bin/bash
# @file
# Create aliases of all the .sh scripts in this dir
# @author Alister Lewis-Bowen (alister@different.com)

BASE=`dirname $0`;
ALIASES=~/.script_aliases;

if [ ! -e $ALIASES ]; then touch $ALIASES; fi;

for script in `find $BASE/ -name "*.sh"`; do
	script=`basename $script`;
	echo alias ${script/.sh/}=\'$script\' >> $ALIASES;
done;

exit 0;
