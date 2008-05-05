#!/bin/bash
# ----------------------------------------------------------------------------
# @file
# Check out a version of Drupal core direct from CVS in a dir named 
# using the CVS tag
# @see color
# @author Alister Lewis-Bowen (alister@different.com)
# ----------------------------------------------------------------------------

REPO='-d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib';
LOG=/tmp/`basename $0`.log;

# Function: Help
# ----------------------------------------------------------------------------

function help {
	echo;
	echo "Usage: $(color bd)drupal_co.sh$(color) [$(color ul)version$(color)]";
	echo "where $(color ul)version$(color) is 4, 5, 6, or HEAD (default)";
	echo;
	exit 1;
}

# Parse input arguments
# ----------------------------------------------------------------------------

case $1 in
	'-h' | '--help')
		help;
		;;
	4)
		TAG=DRUPAL-4-7;
		;;
	5)
		TAG=DRUPAL-5;
		;;
	6)
		TAG=DRUPAL-6;
		;;
	*)
		TAG=HEAD
		;;
esac;

# Parse input arguments
# ----------------------------------------------------------------------------

echo -n "Fetching $(color white blue) core $(color) from Drupal CVS ($(color yellow)$TAG$(color)...";
cvs $REPO -Q co -d $TAG -r $TAG drupal 2>$LOG;
echo " $(color green)Done$(color)";

exit 0;
