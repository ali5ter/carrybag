#!/bin/bash
# ----------------------------------------------------------------------------
# @file
# Check out a version of a Drupal contrib project direct from CVS
# @see color
# @author Alister Lewis-Bowen (alister@different.com)
# ----------------------------------------------------------------------------

PROJECT=$1;
BRANCH=$2;
VERSION=$3;
REPO='-d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib';
REPODIR=contributions/modules/;
TAG=HEAD;
LOG=/tmp/`basename $0`.log;

# Function: Help
# ----------------------------------------------------------------------------

function help {
	echo;
	echo "Usage: $(color bd)drupal_module_co.sh project$(color) [$(color ul)branch$(color)] [$(color ul)version$(color)]";
	echo "where $(color ul)project$(color) is the name of the module project,";
	echo "      $(color ul)branch$(color) is 4, 5, 6, or HEAD (default), ";
	echo "      $(color ul)version$(color) is an integer (defaults to the latest version)";
	echo;
	exit 1;
}

# Parse input arguments
# ----------------------------------------------------------------------------

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


# Check if the project dir exists
# ----------------------------------------------------------------------------

if [ -d $PROJECT ]; then
	echo "$(color yellow)This project has already been checked out.$(color)";
	exit 1;
fi;

# Check out project module from the DRUPAL contrib CVS 
# ----------------------------------------------------------------------------

echo -n "Fetching $(color white blue) $PROJECT $(color) module\t";

if [ "$VERSION" ]; then
	
	# Check out a specific version...
	
	TAG="$TAG--$VERSION";
	echo -n " ($(color yellow)$TAG$(color))...";
	cvs $REPO -Q co -d $PROJECT -r $TAG $REPODIR$PROJECT
	if [ ! -d $PROJECT ]; then
		echo " $(color red)Unable to checkout this project module.$(color)";
		exit 1;
	fi;
	
else

	# Find latest version...
	
	CHECKOUT_VERSION_TAG=0
	CHECKOUT_TAG=1
	CHECKOUT_HEAD=2
	PROJECT_NOT_FOUND=;
	TAG_NOT_FOUND=;
	EXIT=NO;
	TRIES=0;
	
	if [ "$TAG" == 'HEAD' ]; then CHECKOUT=$CHECKOUT_HEAD;
	else CHECKOUT=$CHECKOUT_VERSION_TAG;
	fi;
	
	until [[ -d $PROJECT || "$PROJECT_NOT_FOUND" != ''  || "$EXIT" == 'YES' ]]; do
	
		case "$CHECKOUT" in
		
			"$CHECKOUT_VERSION_TAG" )
				if [ -z "$_TAG" ]; then
					VERSION=9;
					_TAG=$TAG--$VERSION;
				fi;
				if (("$VERSION" > "1")); then
					VERSION=$[$VERSION -1];
					_TAG=$TAG--$VERSION;
				else 
					CHECKOUT=$CHECKOUT_TAG;
				fi;
				;;
				
			"$CHECKOUT_TAG" )
				if [ "$_TAG" == "$TAG" ]; then
					CHECKOUT=$CHECKOUT_HEAD;
				else
					_TAG=$TAG;
				fi;
				;;
				
			"$CHECKOUT_HEAD" )
			  if [ "$_TAG" == 'HEAD' ]; then
					EXIT=YES;
				else
					_TAG=HEAD;
				fi;
			  ;;
			  
			* )
				EXIT=YES;
				;;
		esac;
		
		cvs $REPO -Q co -d $PROJECT -r $_TAG $REPODIR$PROJECT 2>$LOG;
		
		PROJECT_NOT_FOUND=`cat $LOG | grep 'could not read RCS file'`;
		TAG_NOT_FOUND=`cat $LOG | grep 'no such tag'`;
		
		echo -n '.';
		
	done;

	if [ "$PROJECT_NOT_FOUND" != '' ]; then
		echo " $(color red)Unable to find this project module.$(color)";
		exit 1;
	fi;
	
	echo -n " ($(color yellow)$_TAG$(color))";
fi;

echo " $(color green)Done$(color)";

exit 0;
