#!/bin/bash
# @file
# Check out a version of Drupal core direct from CVS in a dir named 
# using the CVS tag
# @author Alister Lewis-Bowen (alister@different.com)

export PATH=$PATH:`dirname $0`/../lib; 

BRANCH=$1;

function help {
	echo;
	echo "Usage: $(color bd)drupal_co.sh$(color off) [$(color bd)version$(color off)]";
	echo "where $(color bd)version$(color off) is 4, 5, 6, or HEAD (default)";
	echo;
	exit 1;
}

case $BRANCH in
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

echo -n "$(color bd)Fetching $(color white blue)$(color bd)core$(color off) $(color bd)from Drupal CVS ($(color yellow)$TAG$(color off)$(color bd))...$(color off)";
cvs -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal checkout -d $TAG -r $TAG drupal >/tmp/`basename $0`.log 2>&1;
echo " $(color green)Done$(color off)";

exit 0;
