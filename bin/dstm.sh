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

CVS_CONTRIB_REPO_DIR=${DSTM_CVS_CONTRIB_REPO_DIR:-contributions/modules};

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
			if [[ "$VERBOSE" || "$VERY_VERBOSE" ]]; then echo " $(color green)Done$(color)"; fi;
			;;
		* )
			if [[ "$VERBOSE" || "$VERY_VERBOSE" ]]; then echo -en "$1...\t"; fi;
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

# Function: Create a list of branches from the profile
# ----------------------------------------------------------------------------

function profileBranches() {
	if [[ -e $PROFILE && `cat $PROFILE | egrep ^IncludeBranch | wc -l | tr -d ' '` != '0' ]]; then
		local _index=0;
		for _branch in `cat $PROFILE | egrep ^IncludeBranch | awk {'print $2'}`; do
			BRANCHES[$_index]=$_branch;
			(( _index += 1 ));
		done;
	fi;
}

# Function: Create a list of include modules from the profile
# ----------------------------------------------------------------------------

function profileModules() {
	if [[ -e $PROFILE && `cat $PROFILE | egrep ^IncludeModule | wc -l | tr -d ' '` != '0' ]]; then
		local _index=0;
	 	for _project in `cat $PROFILE | egrep ^IncludeModule | awk {'print $2'}`; do
	 		MODULES[$_index]=$_project;
			(( _index += 1 ));
	 	done;
	fi;
}

# Function: Build the local Drupal source tree
# ----------------------------------------------------------------------------

function build() {
	VERY_VERBOSE=1;
	profileBranches;
	profileModules;
	get core;
	get module;
	get theme;
}

# Function: Retrieve/get a context within the Drupal source tree
# Usage: get [core|module|theme] [project] [branch] [version]
# ----------------------------------------------------------------------------

function get() {
	local _context=${1:-$CONTEXT};
	local _project=${2:-$PROJECT};
	local _branch=${3:-$BRANCH};
	local _version=${4:-$VERSION};
	
	case "$_context" in
	
		core )
			if [ "$_branch" ]; then
				cvsCoCore $_branch;
			else
				if [ "$BRANCHES" ]; then
					for ((i=0;i<${#BRANCHES[@]};i++)); do
						cvsCoCore ${BRANCHES[${i}]};
					done;
				else 
					cvsCoCore;
				fi;
			fi;;
			
		module )
			if [ "$_project" ]; then
				if [ "$_branch" ]; then
					cvsCoModule $_project $_branch $_version;
				else
					if [ "$BRANCHES" ]; then
						for ((i=0;i<${#BRANCHES[@]};i++)); do
							if [ `cat $PROFILE | egrep ^ExcludeModule | egrep $_project | egrep ${BRANCHES[${i}]} | wc -l | tr -d ' '` == '0' ]; then
								cvsCoModule $_project ${BRANCHES[${i}]} $_version;
							fi;
						done;
					else 
						cvsCoModule $_project;
					fi;
				fi;
			else
				if [ "$MODULES" ]; then
					for ((i=0;i<${#MODULES[@]};i++)); do
						if [ "$BRANCHES" ]; then
							for ((j=0;j<${#BRANCHES[@]};j++)); do
								if [ `cat $PROFILE | egrep ^ExcludeModule | egrep ${MODULES[${i}]} | egrep ${BRANCHES[${j}]} | wc -l | tr -d ' '` == '0' ]; then
									cvsCoModule ${MODULES[${i}]} ${BRANCHES[${j}]} $_version;
								fi;
							done;
						else 
							cvsCoModule ${MODULES[${i}]};
						fi;
					done;
				else 
					cvsCoModule $_project;
				fi;
			fi;;
			
	esac;
}

# Function: Update a context within the Drupal source tree
# Usage: update [core|all] [branch]
# Usage: update [module|theme|all] [project|all] [branch] [version]
# ----------------------------------------------------------------------------

function update() {
	local _context=${1:-$CONTEXT};
	local _project=${2:-$PROJECT};
	local _branch=${3:-$BRANCH};
	local _version=${3:-$VERSION};
	
	case "$_context" in
	
		'' | all )
			update core;
			update module;
			;;
			
		core )
			cd $TREE_CORE;
			case "$_branch" in
				'' | all )
					for _dir in `ls`; do
						cvsUpCore $_dir; 
					done;;
				* )
					cvsUpCore $_branch;;	
			esac;;
			
		module )
			cd $TREE_MODULE;
			case "$_project" in
				'' )
					for _dir in `ls`; do
						cd $TREE_MODULE/$_dir;
						for _project in `ls`; do
							cvsUpModule $_project $_dir;
						done;
					done;;
				all )
					if [[ -d $_branch && "$_branch" ]]; then
						cd $_branch;
						for _project in `ls`; do
							cvsUpModule $_project $_branch;
						done;
					else
						for _dir in `ls`; do
							cd $TREE_MODULE/$_dir;
							for _project in `ls`; do
								cvsUpModule $_project $_dir;
							done;
						done;
					fi;;	
				* )
					if [ "$_branch" ]; then
						cvsUpModule $_project $_branch;
					else
						for _dir in `find . | egrep $_project\\.info | cut -d'/' -f2`; do
							cvsUpModule $_project $_dir; 
						done;
					fi;; 
			esac;;
	esac;
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
	local _tag;
	local _dir;
	
	case "$1" in
		HEAD | '' ) _tag=HEAD; _dir=HEAD;;
		* )					_tag=DRUPAL-$1; _dir=$1;;
	esac;
	
	cd $TREE_CORE;
	status "Fetching $_tag";
	cvs $CVS_REPO -Q co -d $_dir -r $_tag drupal 2>>$ERROR_LOG;
	status done;
}

# Function: Check out Drupal module project
# Usage: cvsCoModule [project] [branch] [version]
# ----------------------------------------------------------------------------

function cvsCoModule() {
	local _project=${1:-devel};
	local _branch=${2:-HEAD};
	local _version=$3;
	
	if [[ -e $PROFILE && `cat $PROFILE | egrep ^LockModuleVersion | egrep $_project | egrep $_branch | wc -l | tr -d ' '` != '0' ]]; then
		_version=`cat $PROFILE | egrep ^LockModuleVersion | egrep $_project | egrep $_branch | awk {'print $4'}`;
	fi;

	if [ ! -d $TREE_MODULE/$_branch ]; then 
		mkdir -p $TREE_MODULE/$_branch;
	fi;
	cd $TREE_MODULE/$_branch;
	
	local _tag;
	case "$_branch" in
		HEAD )	_tag=HEAD; _dir=HEAD;;
		* )			_tag=DRUPAL-$_branch; _dir=$_project;;
	esac;
	
	if [ "$_version" ]; then
		# @todo _version =~ s/./-/g
		_tag=$_tag--$_version;
	fi;
	
	status "Fetching $_project module ($_tag)";

	if [ "$FORCE" ]; then
		rm -fR $_project;
	fi;
	
	if [ -d $_project ]; then 
		status "already exists locally";
		status done;
		return;
	fi;

	if [ "$_version" ]; then
	
		# Check out a specific version...
	
		status " ($_tag)";
		cvs $CVS_CONTRIB_REPO -Q co -d $_project -r $_tag $CVS_CONTRIB_REPO_DIR/$_project
		if [ ! -d $_project ]; then
			status "unable to checkout this project module";
			status done;
			return;
		fi;
	
	else
	
		# Find latest version...
		
		local _checkout_by_version=0
		local _checkout_by_branch=1
		local _checkout_head=2
		local _project_not_found;
		local _tag_not_found;
		local _try_tag;
		local _exit=NO;
		local _log=.tmp_log;
		
		touch $_log;
		
		if [ "$_tag" == 'HEAD' ]; then _checkout=$_checkout_head;
		else _checkout=$_checkout_by_version;
		fi;
		
		until [[ -d $_project || "$_project_not_found" != ''  || "$_exit" == 'YES' ]]; do
		
			case "$_checkout" in
			
				"$_checkout_by_version" )
					if [ -z "$_try_tag" ]; then
						_version=8;	# not spotted any versions higher than 7
						_try_tag=$_tag--$_version;
					fi;
					if (("$_version" > "1")); then
						_version=$[$_version -1];
						_try_tag=$_tag--$_version;
					else 
						_checkout=$_checkout_by_branch;
					fi;
					;;
					
				"$_checkout_by_branch" )
					if [ "$_try_tag" == "$_tag" ]; then
						_checkout=$_checkout_head;
					else
						_try_tag=$_tag;
					fi;
					;;
					
				"$_checkout_head" )
				  if [ "$_try_tag" == 'HEAD' ]; then
						_exit=YES;
					else
						_try_tag=HEAD;
					fi;
				  ;;
				  
				* )
					_exit=YES;
					;;
			esac;
			
			cvs $CVS_CONTRIB_REPO -Q co -d $_project -r $_try_tag $CVS_CONTRIB_REPO_DIR/$_project 2>$_log;
			
			_project_not_found=`cat $_log | grep 'could not read RCS file'`;
			_tag_not_found=`cat $_log | grep 'no such tag'`;
			
			if [ "$VERY_VERBOSE" ]; then
				echo -n '.';
			fi;
			
		done;
	
		cat $_log >> $ERROR_LOG;
		rm $_log;
		
		if [ "$_project_not_found" != '' ]; then
			status "unable to find this project module";
			status done;
			return;
		fi;
		
		if [ "$VERY_VERBOSE" ]; then
			echo -n "$_try_tag";
		fi;
		
	fi;

	status done;
}

# Function: Update Drupal core
# Usage: cvsUpCore [branch]
# ----------------------------------------------------------------------------

function cvsUpCore() {
	local _tag;
	local _dir;
	
	case "$1" in
		HEAD | '' ) _tag=HEAD; _dir=HEAD;;
		* )					_tag=DRUPAL-$1; _dir=$1;;
	esac;
	
	if [ -d $TREE_CORE/$_dir ]; then
		cd $TREE_CORE/$_dir;
		status "Updating $_tag";
		cvs -Q up -d -P 2>>$ERROR_LOG;
		status done;
	else
		error "Oops! It seems core $_dir does not exist. Perhaps you should use the dstm get core $_dir command.";
	fi;
}

# Function: Update Drupal module project
# Usage: cvsUpModule [project] [branch]
# ----------------------------------------------------------------------------

function cvsUpModule() {
	local _project=${1:-devel};
	local _branch=${2:-HEAD};
	
	if [ -d $TREE_MODULE/$_branch/$_project ]; then
		cd $TREE_MODULE/$_branch/$_project;
		status "Updating $_project module ($_branch)";
		cvs -Q up -d -P 2>>$ERROR_LOG;
		status done;
	else
		error "Oops! It seems module $_project $_branch does not exist. Perhaps you should use the dstm update module $_project $_branch command.";
	fi;
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

# Parse input arguments
# ----------------------------------------------------------------------------

if [ -z "$1" ]; then help; fi;

while (( "$#" )); do

	case "$1" in
		
		# Options
		-v | --verbose )	VERBOSE=1;;
		-vv | --vverbose )	VERY_VERBOSE=1;;
		-f | --force )		FORCE=1;;
		
		# General actions
		help )						help;;
		init )  					clean; profile; build;;
		clean )						clean;;
		profile )					profile;;
		build )						build;;
		refresh )					refresh;;
		
		# Context for an action
		core | C )				CONTEXT=core;;
		module | M )			CONTEXT=module;;
		theme | T)				CONTEXT=theme;;
		
		# Action based on context
		retrieve | get )	ACTION=get;;
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

echo "VERBOSE($VERBOSE) VERY_VERBOSE($VERY_VERBOSE) FORCE($FORCE) ACTION($ACTION) CONTEXT($CONTEXT) PROJECT($PROJECT) BRANCH($BRANCH) VERSION($VERSION)";

case "$ACTION" in
	get )			get $CONTEXT $PROJECT $BRANCH $VERSION;;
	update )	update $CONTEXT $PROJECT $BRANCH;;
	delete )	delete $CONTEXT $PROJECT $BRANCH;;
esac

exit 0;
