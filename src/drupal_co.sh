#!/bin/bash
# @file
# Check out a version of Drupal core direct from CVS
# Usage: drupal_co [version]
# where version is 4,5,6 or HEAD (default)
# @author Alister Lewis-Bowen (alister@different.com)

BRANCH=$1; # default to HEAD branch
TAG=HEAD;

if [ $BRANCH = '4' ]; then TAG=DRUPAL-4-7;
elif [ $BRANCH = '5' ]; then TAG=DRUPAL-5;
elif [ $BRANCH = '6' ]; then TAG=DRUPAL-6;
elif [ $BRANCH != 'HEAD' ]; then echo "BRANCH must be 4, 5, 6 or HEAD";
fi

echo "Fetching core from Drupal CVS ($TAG)...";
cvs -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal checkout -d $TAG -r $TAG drupal

echo 'Done';

exit 0;
