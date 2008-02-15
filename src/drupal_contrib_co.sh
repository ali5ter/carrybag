#!/bin/bash
# $Id: drupal_contrib_co,v 1.12 2008/02/15 14:41:48 abowen Exp $

PROJECT=$1;
BRANCH=${2:-HEAD};	# default to HEAD branch
VERSION=${3:-1};	# default to version 1

if [ -z $PROJECT ]; then
	echo "Usage: drupal_contrib_co project_name [5|6|HEAD] [version_number]";
	exit 1;
fi

if [ $BRANCH = '5' ]; then TAG=DRUPAL-5;
elif [ $BRANCH = '6' ]; then TAG=DRUPAL-6;
elif [ $BRANCH != 'HEAD' ]; then echo "BRANCH must be 5, 6 or HEAD";
fi

if [ $BRANCH = '6' ]; then
	TAG="$BRANCH--$VERSION";
fi

echo "Fetching '$PROJECT' from Drupal Contrib CVS ($TAG)...";
cvs -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib checkout -d $PROJECT -r $TAG contributions/modules/$PROJECT;
echo 'Done';
