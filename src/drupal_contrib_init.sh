#/bin/sh
# @file
# Check out a set of Drupal contrib projects direct from CVS in the current dir
# Usage: drupal_contrib_init [core_version]
# where core_version is 4, 5, 6 or HEAD (default)
#       version is an integer, defaulting to 1
# @author Alister Lewis-Bowen (alister@different.com)

BRANCH=${1:-HEAD}; # default to HEAD

for module in actions \
	ajaxim \
	asset \
	backup_migrate \
	biblio \
	buddylist \
	cck \
	coder \
	contemplate \
	custom_breadcrumbs \
	date \
	devel \
	event \
	forms \
	google_analytics \
	image \
	imagecache \
	imagefield \
	imce \
	jstools \
	link \
	location \
	logintoboggan \
	mapi \
	mediafield \
	menu_per_role \
	menutrails \
	node_breadcrumb \
	node_media \
	nodeaccess \
	nodehierarchy \
	og \
	override_node_options \
	panels \
	pathauto \
	pictures \
	pngfix \
	profileplus \
	services \
	similarterms \
	simplemenu \
	simpletest \
	suggestedterms \
	survey \
	tinymce \
	token \
	typogrify \
	update_status \
	video views \
	views_bonus \
	workflow \
	workflow_ng; do
	
	drupal_contrib_co.sh $module $BRANCH;
done;

exit 0;


