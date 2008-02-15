#/bin/sh
# $Id: drupal_contrib_init,v 1.2 2008/02/15 15:22:31 abowen Exp $

BASE=/Users/abowen/Development/drupal/contrib;
BRANCH=${1:-HEAD};
VERSION=$2;

case $BRANCH in
	5)
		TARGET_DIR='DRUPAL-5'
		;;
	6)
		TARGET_DIR='DRUPAL-6'
		;;
	*)
		TARGET_DIR='HEAD'
		;;
esac;
cd $BASE/$TARGET_DIR;

for module in actions ajaxim asset backup_migrate biblio buddylist cck coder contemplate custom_breadcrumbs date devel event forms image imagecache imagefield imce jstools link location logintoboggan mapi mediafield menu_per_role menutrails node_breadcrumb node_media nodeaccess nodehierarchy og override_node_options panels pathauto pictures pngfix profileplus services similarterms simplemenu simpletest suggestedterms survey tinymce token typogrify update_status video views views_bonus workflow workflow_ng; do
	if [ $BRANCH = "HEAD" ]; then
		VERSION='';
	fi;
	/Users/abowen/bin/drupal_contrib_co $module $BRANCH $VERSION;
done;


