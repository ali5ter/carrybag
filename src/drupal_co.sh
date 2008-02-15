#!/bin/bash
# $Id: drupal_co,v 1.4 2008/02/15 14:10:59 abowen Exp $

BRANCH=${1:-HEAD};
if [ $BRANCH = '4' ]; then BRANCH=DRUPAL-4-7;
elif [ $BRANCH = '5' ]; then BRANCH=DRUPAL-5;
elif [ $BRANCH = '6' ]; then BRANCH=DRUPAL-6;
elif [ $BRANCH != 'HEAD' ]; then echo "Usage: drupal_co [4|5|6|HEAD]";
fi
echo "Fetching core from Drupal CVS ($BRANCH)...";
cvs -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal checkout -d $BRANCH -r $BRANCH drupal
echo 'Done';
