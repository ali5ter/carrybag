#!/bin/bash
# ----------------------------------------------------------------------------
# @file
# Check out a version of a Drupal contrib project direct from CVS
# @see color
# @author Alister Lewis-Bowen (alister@different.com)
# ----------------------------------------------------------------------------

REPO='-d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib';
REPODIR=contributions/modules/;
TAG=HEAD;
LOG=/tmp/`basename $0`.log;
OVERRIDE_FILE=.`basename $0 .sh`.override;

# Function: Help
# ----------------------------------------------------------------------------

function help {
	echo;
	echo "Usage: $(color bd)drupal_module_co.sh$(color) [$(color ul)options$(color)] $(color ul)project$(color) [$(color ul)branch$(color)] [$(color ul)version$(color)]";
	echo "where $(color ul)options$(color) are -h, --help for this help text or";
	echo "      -f, --force to force the checkout even if the module already exists";
	echo "      -i, --info to display the module info file after checkout.";
	echo "      $(color ul)project$(color) is the name of the module project,";
	echo "      $(color ul)branch$(color) is 5, 6, or HEAD (default), ";
	echo "      $(color ul)version$(color) is an integer (defaults to the latest version)";
	echo;
	echo "Examples:";
	echo " drupal_module_co devel 5";
	echo "will checkout the devel module using the DRUPAL-5 branch and the latest"; 
	echo "version found in the CVS repository. If ./devel already exists, no";
	echo "checkout will occur.";
	echo " drupal_module_co -f workflow 5 2-2";
	echo "will checkout the workflow module using DRUPAL-5--2-2. With the force";
  echo "option, any existing ./workflow directory will be deleted before the ";
	echo "checkout begins.";
	echo;
	echo "You can override branch and version numbers for specific modules by";
	echo "using a .$0.override file that lists these. An example might be..";
	echo;
	echo "# Workflow/action dependency...";
	echo "actions 5 2-4";
	echo "workflow 5 2-2";
	echo;
	echo "where the first line is comment, the second line forces the checkout of";
	echo "the actions module for branch 5 version 2-4 (DRUPAL-5--2-4) and the last";
	echo "line defines the checkout of the workflows module for branch 5 version";
	echo "2-2 (DRUPAL-5--2-2)";
	echo;
	echo "Using this override file means that any command acting on the action or";
	echo "workflow module will only ever use the branch and version information";
	echo "from the override file."
	echo;
	exit 1;
}

# Function: Display the module info file
# ----------------------------------------------------------------------------

function show_module_info() {
	if [-e $PROJECT/$PROJECT.info ]; then 
  	echo; 
  	cat $PROJECT/$PROJECT.info; 
  	echo; 
	fi;
}

# Function: Override settings
# ----------------------------------------------------------------------------

function override() {
	if [ -e $OVERRIDE_FILE ]; then
		BRANCH=`cat $OVERRIDE_FILE | egrep $PROJECT | awk {'print $2'}`;
		VERSION=`cat $OVERRIDE_FILE | egrep $PROJECT | awk {'print $3'}`;
	fi;
}

# Parse input arguments
# ----------------------------------------------------------------------------

while (( "$#" )); do

	case "$1" in
		-f | --force )
			DELETE=1;
			;;
		-h | --help )
			help;
			;;
		-i | --info )
			INFO=1;
			;;
		*)
			if [ -z "$PROJECT" ]; then
				PROJECT=$1;
			else
				if [ -z "$BRANCH" ]; then
					BRANCH=$1;
				else
					if [ -z "$VERSION" ]; then
						VERSION=$1;
					fi;
				fi;
			fi;
	esac
	
	shift;
	
done;

if [ -z "$PROJECT" ]; then help; fi;

override;

# Set the CVS TAG
# ----------------------------------------------------------------------------

case $BRANCH in
	5)
		TAG=DRUPAL-5;
		;;
	6)
		TAG=DRUPAL-6;
		;;
	*)
		TAG=HEAD;
		;;
esac;

if [ "$VERSION" ]; then TAG=$TAG--$VERSION; fi;

# Check out project module from the DRUPAL contrib CVS 
# ----------------------------------------------------------------------------

echo -en "Drupal module:\t$(color white blue) $PROJECT $(color)\t";

if [ -e $LOG ]; then rm -f $LOG; fi;

if [ "$DELETE" ]; then 
  rm -fR ./$PROJECT 2>>$LOG;
fi;

if [ -d $PROJECT && -n "$INFO" ]; then 
	show_module_info;
	exit 0; 
fi;

if [ -d $PROJECT ]; then 
	echo " $(color yellow)Already checked out.$(color)";
	exit 1;
fi;

if [ "$VERSION" ]; then
	
	# Check out a specific version...
	
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
		
		cvs $REPO -Q co -d $PROJECT -r $_TAG $REPODIR$PROJECT 2>>$LOG;
		
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

if [ "$INFO" ]; then show_module_info; fi;

exit 0;
