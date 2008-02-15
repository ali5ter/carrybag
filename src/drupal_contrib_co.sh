#!/bin/bash
# @file
# Check out a version of Drupal contrib project direct from CVS
# Usage: drupal_contrib_co [core_version] [version]
# where core_version is 4, 5, 6 or HEAD (default)
#       version is an integer, defaulting to 1
# @author Alister Lewis-Bowen (alister@different.com)

PROJECT=$1;
BRANCH=${2:-HEAD};	# default to HEAD branch
VERSION=${3:-1};	# default to version 1

TAG=HEAD;

if [ -z $PROJECT ]; then
	echo "Usage: drupal_contrib_co project_name [4|5|6|HEAD] [version_number]";
	exit 1;
fi

if [ $BRANCH = '4' ]; then TAG=DRUPAL-4-7;
elif [ $BRANCH = '5' ]; then TAG=DRUPAL-5;
elif [ $BRANCH = '6' ]; then TAG=DRUPAL-6;
elif [ $BRANCH != 'HEAD' ]; then echo "BRANCH must be 4, 5, 6 or HEAD";
fi

# New tag system in branch 6 (sort of in 5 but came out foo)
if [ $BRANCH = '6' ]; then
	TAG="$TAG--$VERSION";
fi

echo "Fetching '$PROJECT' from Drupal Contrib CVS ($TAG)...";
cvs -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib checkout -d $PROJECT -r $TAG contributions/modules/$PROJECT;

echo 'Done';

exit 0;
