#!/bin/bash
# ----------------------------------------------------------------------------
# @file dstm.sh
# Simple Drupal src tree manager
# @see color
# @author Alister Lewis-Bowen [alister@different.com]
# ----------------------------------------------------------------------------
# This software is distributed under the the MIT License.
#
# Copyright (c) 2008 Alister Lewis-Bowen
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# ----------------------------------------------------------------------------

# Base directory of local Drupal source tree
# ----------------------------------------------------------------------------

BASE=${DSTM_BASE:-~/.dstm};

# Drupal CVS core repository
# ----------------------------------------------------------------------------

CVS_REPO=${DSTM_CVS_REPO:-'-d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal'};

# Drupal CVS contrib repository
# ----------------------------------------------------------------------------

CVS_CONTRIB_REPO=${DSTM_CVS_CONTRIB_REPO:-'-d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib'};

# Drupal contrib module directory in the CVS repository
# ----------------------------------------------------------------------------

CVS_CONTRIB_REPO_DIR=${DSTM_CVS_CONTRIB_REPO_DIR:-contributions/modules/};

# Core location in the Drupal source tree
# ----------------------------------------------------------------------------

TREE_CORE=${DSTM_TREE_CORE:-$BASE/core};

# Contrib module location in the Drupal source tree
# ----------------------------------------------------------------------------

TREE_MODULE=${DSTM_TREE_MODULE:-$BASE/contrib/modules};

# Contrib themes location in the Drupal source tree
# ----------------------------------------------------------------------------

TREE_THEME=${DSTM_TREE_THEME:-$BASE/contrib/themes};

# Profile desciption of the Drupal source tree
# ----------------------------------------------------------------------------

PROFILE=${DSTM_PROFILE:-$BASE/profile};

# Default CVS tag
# ----------------------------------------------------------------------------

ERROR_LOG=${DSTM_ERROR_LOG:-$BASE/error.log};

# Function: Help
# ----------------------------------------------------------------------------

function help {
	clear;
	echo "$(color bd)NAME$(color)";
	echo -e "\tdstm -- simple Drupal source tree manager";
	echo;
	echo "$(color bd)SYNOPSIS$(color)";
	echo;
	echo "$(color bd)DESCRIPTION$(color)";
	echo;
	echo "$(color bd)EXAMPLES$(color)";
	echo;
	echo "$(color bd)ENVIRONMENT$(color)";
	echo;
	echo "$(color bd)AUTHOR$(color)";
	echo -e "\tWritten by Alister Lewis-Bowen";
	echo;
	echo "$(color bd)REPORTING BUGS$(color)";
	echo -e "\t Report bugs to <feedback@different.com>.";
	echo;
	echo "$(color bd)LICENSE$(color)";
	echo -e "\tCopyright (c) 2008 Alister Lewis-Bowen.";
	echo;
	echo -e "\tThis software is distributed under the the MIT License.";
	echo;
	echo "$(color bd)SEE ALSO$(color)";
	echo;
	exit 1;
}

# Function: Echo a status message
# Usage: status [<string>|done]
#				 status error <string>
# ----------------------------------------------------------------------------

function status() {
	case "$1" in
		error )
			echo -e "$(color red)Error:$(color) $2";
			exit 1;
			;;
		done )
			if [ -z "$QUIET" ]; then echo " $(color green)Done$(color)"; fi;
			;;
		* )
			if [ -z "$QUIET" ]; then echo -en "$1...\t"; fi;
			;;
	esac;
}

# Function: Clean the local Drupal source tree
# ----------------------------------------------------------------------------

function clean() {
	echo -n "I am going to clean the source tree. ";
	echo "All the contents of $BASE will be deleted and a fresh empty tree structure will be created.";
	echo -n "$(color bd)Are you ready to continue (Yes|No) ? $(color off): ";
	read confirmation;
	if [ "$confirmation" != 'Yes' ]; then
		echo "$(color green)$(color bd)Cancelling$(color off)";
		exit 1;
	fi;
	echo;
	status "Cleaning the local source tree...";
	rm -fR $BASE;
	mkdir -p $TREE_CORE $TREE_MODULE $TREE_THEME;
	touch $ERROR_LOG;
	status done;
}

# Function: Example data for a dstm profile
# ----------------------------------------------------------------------------

function profile() {
	status "Creating sample profile...";
	if [ ! -e $PROFILE ]; then
		cat > $PROFILE <<'endOfExampleProfileContent'
# ----------------------------------------------------------------------------
# @file Drupal source tree manager (dstm) Profile
# @version $Id$
# ----------------------------------------------------------------------------

# INCLUDE BRANCHES TO THE SOURCE TREE
# ----------------------------------------------------------------------------
# Add the branches that should appear in the local Drupal source tree. By 
# default the HEAD branch will be built if nothing is defined here.
# e.g. IncludeBranch 6
IncludeBranch 5
IncludeBranch 6
IncludeBranch HEAD

# INCLUDE MODULES WHEN BUILDING THE SOURCE TREE
# ----------------------------------------------------------------------------
# Add the modules that should be included for each branch defined above. These
# are checked out of CVS when the source tree is built. 
# e.g. IncludeModule devel
IncludeModule backup_migrate
IncludeModule devel
IncludeModule simplemenu
IncludeModule logintoboggan
IncludeModule pngfix
IncludeModule typogrify

# EXCLUDE MODULES WHEN BUILDING THE SOURCE TREE 
# ----------------------------------------------------------------------------
# Define which of the modules defined about should not be included into a
# branch.
# e.g. ExcludeModule backup_migrate 6
ExcludeModule backup_migrate 6

# LOCK A MODULE TO A SPECIFIC VERSION
# ----------------------------------------------------------------------------
# To help define module version dependencies within branches, use the
# LockModuleVersion stanza to specify a version for a branch. This is override
# any 'dstm get' command for the defined module, effectively locking down its
# version.
# e.g. LockModuleVersion date 5 1-8
LockModuleVersion image 5 1-8
LockModuleVersion date 5 1-8
LockModuleVersion actions 5 2-4
LockModuleVersion workflow 5 2-2
endOfExampleProfileContent
	fi;
	status done;
}

# Function: Built the local Drupal source tree
# ----------------------------------------------------------------------------

function build() {
	create core;
	create module;
	create theme;
}

# Function: Create a context within the Drupal source tree
# Usage: create [core|module|theme] [project] [branch] [version]
# ----------------------------------------------------------------------------

function create() {
	local _context=${1:-$CONTEXT};
	local _project=${2:-$PROJECT};
	local _branch=${3:-$BRANCH};
	local _version=${3:-$VERSION};
	case "$_context" in
		core )
			if [ -n "$_branch" ]; then
				cvsCoCore $_branch;
			else
				if [[ -e $PROFILE && `cat $PROFILE | egrep ^IncludeBranch | wc -l | tr -d ' '` != '0' ]]; then
					for _branch in `cat $PROFILE | egrep ^IncludeBranch | awk {'print $2'}`; do
						cvsCoCore $_branch;
					done;
				else
					cvsCoCore;
				fi;
			fi;;
		module )
			;;
		theme )
			;;
	esac;
}

# Function: Retrieve/get a context within the Drupal source tree
# Usage: get [core|module|theme] [project] [branch] [version]
# ----------------------------------------------------------------------------

function get() {
	local _context=${1:-$CONTEXT};
	local _project=${2:-$PROJECT};
	local _branch=${3:-$BRANCH};
	local _version=${3:-$VERSION};
}

# Function: Update a context within the Drupal source tree
# Usage: update [core|module|theme] [project] [branch] [version]
# ----------------------------------------------------------------------------

function update() {
	local _context=${1:-$CONTEXT};
	local _project=${2:-$PROJECT};
	local _branch=${3:-$BRANCH};
	local _version=${3:-$VERSION};
}

# Function: Delete a context within the Drupal source tree
# Usage: delete [core|module|theme] [project] [branch] [version]
# ----------------------------------------------------------------------------

function delete() {
	local _context=${1:-$CONTEXT};
	local _project=${2:-$PROJECT};
	local _branch=${3:-$BRANCH};
	local _version=${3:-$VERSION};
}

# Function: Check out Drupal core
# Usage: cvsCoCore [branch]
# ----------------------------------------------------------------------------

function cvsCoCore() {
	local _DIR=${1:-HEAD};
	local _TAG=DRUPAL-$1;
	if [ "$_DIR" == 'HEAD' ]; then _TAG=HEAD; fi;
	status "Fetching $_TAG";
	cd $TREE_CORE;
	cvs $CVS_REPO -Q co -d $_DIR -r $_TAG drupal 2>>$ERROR_LOG;
	status done;
}


# Function: Display the project info files
# ----------------------------------------------------------------------------

function displayProjectInfo() {
	if [ -e $BASE/contrib/module/$PROJECT/$PROJECT.info ]; then 
  	echo; 
  	cat $PROJECT/$PROJECT.info; 
  	echo; 
	fi;
}

# Function: Get any overriding branch and version values for a project
# ----------------------------------------------------------------------------

function getProjectOverride() {
	if [ -e $MODULE_OVERRIDE ]; then
		BRANCH=`cat $MODULE_OVERRIDE | egrep $PROJECT | awk {'print $2'}`;
		VERSION=`cat $MODULE_OVERRIDE | egrep $PROJECT | awk {'print $3'}`;
	fi;
}

# Parse input arguments
# ----------------------------------------------------------------------------

if [ -z "$1" ]; then help; fi;

while (( "$#" )); do

	case "$1" in
		
		# Options
		-q | --quiet )	QUIET=1;;
		
		# General actions
		help )						help;;
		init )  					clean; profile; build;;
		clean )						clean;;
		profile )					profile;;
		build )						build;;
		
		# Context for an action
		core | C )				CONTEXT=core;;
		module | M )			CONTEXT=module;;
		theme | T)				CONTEXT=theme;;
		
		# Action based on context
		create | cr )			ACTION=create;;
		retrieve | get )	ACTION=retrieve;;
		update | up )			ACTION=update;;
		delete | del )		ACTION=delete;;
		
		# Parse project, branch and version based on context
		*)
			case "$CONTEXT" in
					
				core )
					if [ -z "$BRANCH" ]; then 
						BRANCH=$1;
					else status error "The core context only takes the branch argument.";
					fi;;
					
				module | theme )
					if [ -z "$PROJECT" ]; then 
						PROJECT=$1; 
					else 
						if [ -z "$BRANCH" ]; then 
							BRANCH=$1;
						else 
							if [ -z "$VERSION" ]; then 
								VERSION=$1;
							else status error "The module and theme context only take the project, branch and version arguments.";
							fi;
						fi;
					fi;;
					
			esac;; # case $CONTEXT
			
	esac # case $1
	
	shift;

done;

# Invoke and action
# ----------------------------------------------------------------------------

## DEBUG
echo "CONTEXT($CONTEXT) ACTION($ACTION) PROJECT($PROJECT) BRANCH($BRANCH) VERSION($VERSION)";

exit 0;
