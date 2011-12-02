#!/bin/bash
# @file
# Create aliases of all the .sh scripts in this dir
# @author Alister Lewis-Bowen (alister@different.com)

BASE=`dirname $0`;
BIN=~/bin;
ALIASES=~/.script_aliases;

if [ "$1" != '' ]; then BIN=$1; fi;

if [ ! -e $ALIASES ]; then touch $ALIASES; fi;

for script in `find $BASE/ -name "*.sh"`; do
	script=`basename $script`;
	echo alias ${script/.sh/}=\'$BIN/$script\' >> $ALIASES;
done;

exit 0;
