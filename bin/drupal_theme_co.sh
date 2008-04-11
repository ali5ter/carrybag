#!/bin/bash
# @file
# Check out a version of a Drupal theme project direct from CVS
# @see color
# @author Alister Lewis-Bowen (alister@different.com)

PROJECT=$1;
BRANCH=$2;
VERSION=${3:-1};

TAG=HEAD;

function help {
	echo;
	echo "Usage: $(color bd)drupal_theme_co.sh project$(color off) [$(color bd)branch$(color off)] [$(color bd)version$(color off)]";
	echo "where $(color bd)project$(color off) is the name of the theme project,";
	echo "      $(color bd)branch$(color off) is 4, 5, 6, or HEAD (default), ";
	echo "      $(color bd)version$(color off) is an integer (defaults to 1)";
	echo;
	exit 1;
}

if [[ -z $PROJECT || "$PROJECT" = '-h' || "$PROJECT" = '--help' ]]; then help; fi;

case $BRANCH in
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

if [ "$BRANCH" = '6' ]; then TAG="$TAG--$VERSION"; fi # New tag system in branch 6 (sort of in 5 but came out foo)

echo -n "$(color bd)Fetching $(color white blue)$(color bd)$PROJECT$(color off) $(color bd)theme from Drupal Contrib CVS ($(color yellow)$TAG$(color off)$(color bd))...$(color off)";
cvs -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib checkout -d $PROJECT -r $TAG contributions/themes/$PROJECT >/tmp/`basename $0`.log 2>&1;

echo " $(color green)Done$(color off)";

exit 0;