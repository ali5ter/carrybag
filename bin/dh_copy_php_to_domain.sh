!/bin/sh
# @file dh_copy_php_to_domain.sh
# @see http://www.hiveminds.co.uk/node/3201
# ----------------------------------------------------------------------------

# Abort on any errors
set -e

# And where should it be installed?
DOMAIN="iic.different.com"

#copy it for where?
SOURCEDOMAIN="wiki.iic.different.com"

#paths
INSTALLDIR=${HOME}/php5
CGIFILE="$HOME/$SOURCEDOMAIN/cgi-bin/php.cgi"
INIFILE="$HOME/php5/etc/php5/$SOURCEDOMAIN/php.ini"

#copy config file
mkdir -p ${INSTALLDIR}/etc/php5/${DOMAIN}
cp ${INIFILE} ${INSTALLDIR}/etc/php5/${DOMAIN}/php.ini

#copy PHP CGI
mkdir -p ${HOME}/www/${DOMAIN}/cgi-bin
chmod 0755 ${HOME}/www/${DOMAIN}/cgi-bin
cp ${INSTALLDIR}/bin/php ${HOME}/www/${DOMAIN}/cgi-bin/php.cgi
cp ${INSTALLDIR}/bin/php ${HOME}/www/${DOMAIN}/cgi-bin/php5.fcgi

echo ---------- INSTALL COMPLETE! ----------