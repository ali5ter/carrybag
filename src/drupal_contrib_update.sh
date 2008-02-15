#!/bin/bash
# $Id: drupal_contrib_update,v 1.4 2007/11/26 16:18:27 abowen Exp $
DIRS=`find -E . -maxdepth 2 -iregex ".*module"|cut -d"/" -f 2|sort|uniq`;
_PWD=`pwd`;
for dir in $DIRS; do
	cd $_PWD/$dir; 
	cvs update -d -P;
done
cd $_PWD;
echo "Done";

