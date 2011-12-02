#/usr/bin/sh
# -----------------------------------------------------------------------------
# @file init_machine_centos.sh
# Script to set up a CentOS5 system. WARNING: Always a work inprogress, and 
# personal to my own needs.
#
# @author Alister Lewis-Bowen <alister@different.com>
# @see http://www.howtoforge.com/perfect-server-centos-5.2-ispconfig-3-p5
# @see http://www.atomicorp.com/wiki/index.php/PHP
#
# @todo drupal-src
# -----------------------------------------------------------------------------

#
#	Globals
#
USER=alister
HOSTNAME=green.different.com

#
#	Helper functions
#
rcsDir() {
	if [ ! -d RCS ]; then
		mkdir RCS;
	fi;
}

isFile() {
	if [ ! -e $1 ]; then
		touch $1;
	fi;
}
	
rcsRegister () {
	dirName=`dirname $1`;
	fileName=`basename $1`;
	cd $dirName;
	rcsDir $dirName;
	isFile $fileName;
	ci $fileName;
	co $fileName;
}

rcsEdit () {
	dirName=`dirname $1`;
	fileName=`basename $1`;
	cd $dirName;
	rcsDir $dirName;
	isFile $fileName;
	co -l $fileName;
	vi $fileName;
	ci $fileName;
	co $fileName;
}

#
#	Add a new User so we can use this to log in
#
adduser $USER; passwd $USER;
gpasswd -a $USER wheel; gpasswd -a $USER apache;

#
#	Turn of root login using ssh (todo)
#

#
#	Install some generic helper software to get us to the next step
#
yum install rcs wget sudo;

#
#	Make sure we have sudo set up for this user
# 	uncomment  %wheel ALL=(ALL)       ALL   
#
/usr/sbin/visudo;

#
#
#	Enable RPMForge repository
#	(http://dag.wieers.com/rpm/packages/rpmforge-release/)
#
rpm --import http://dag.wieers.com/rpm/packages/RPM-GPG-KEY.dag.txt
cd /tmp
wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.3.6-1.el5.rf.i386.rpm
rpm -ivh rpmforge-release-0.3.6-1.el5.rf.i386.rpm

#
#	Enable Karan repository
#	(http://centos.karan.org/)
#
cd /etc/yum.repos.d/
rpm --import http://centos.karan.org/RPM-GPG-KEY-karan.org.txt
wget http://centos.karan.org/kbsingh-CentOS-Extras.repo

#
#	Enable ART repository (latest PHP)
#	(http://www.atomicorp.com/wiki/index.php/PHP)
#
wget -q -O - http://www.atomicorp.com/installers/atomic.sh | sh

#
#	Update currently installed software
#
yum update;

#
#	Install packages we need
#
yum install php-gd php-mcrypt php-mbstring php-eaccelerator php-mysql mysql-server phpmyadmin rkhunter denyhosts fail2ban subversion cvs aide

#
#	Add a bit of cracker security
#	(Optional, since your VPS system may have brute force SHH protection)
#
rcsRegister /etc/sysconfig/rkhunter
rcsEdit /etc/sysconfig/rkhunter
# update MAILTO=root@localhost
rkhunter --update

/sbin/chkconfig --levels 235 fail2ban on
/etc/init.d/fail2ban start

chkconfig denyhosts on
service debyhosts start

rcsRegister /etc/aide.conf
co -l aide.conf
rm aide.conf; wget http://www.bofh-hunter.com/downloads/aide.conf
ci aide.conf; co aide.conf
/usr/sbin/aide --init
cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
/usr/sbin/aide --check
rcsRegister /etc/cron.weekly/aide.cron
rcsEdit /etc/cron.weekly/aide.cron
##!/bin/bash
#(/usr/sbin/aide --check | /bin/mail -s "($HOSTNAME) Weekly Aide Data" feedback@different.com)

#
#	Configure Apache
# 	define ServerAdmin ServerToken to Prod, ServerName, turn off ServerSig and uncomment NameVirtualHost
#	
rcsRegister /etc/httpd/conf/httpd.conf;
rcsEdit /etc/httpd/conf/httpd.conf;

#
#	Configure Virtual Hosts
#
rcsRegister /etc/httpd/conf.d/vhost.conf
rcsEdit /etc/httpd/conf.d/vhost.conf

#
#	Configure PHP
#	up memory_limit to 96M, post_max_size to 1024M, 
#	error_log to /tmp/php_error.log,
#	error_reporting = E_ALL & ~E_NOTICE
#
rcsRegister /etc/php.ini
rcsEdit /etc/php.ini

#
#	Set up MySQL
#
/sbin/chkconfig --levels 235 mysqld on;
/etc/init.d/mysqld start;
mysqladmin -u root password 'bcuz1@M';
mysqladmin -u root -h $HOSTANME password 'bcuz1@M';

#
#	Configure phpMyAdmin
#	comment out the Directory stanza in phpmyadmin.conf
#	add blowfish secret to config.inc.php
#
rcsEdit /etc/httpd/conf.d/phpmyadmin.conf
chmod 644 /usr/share/phpmyadmin/config.inc.php
rcsRegister /usr/share/phpmyadmin/config.inc.php
rcsEdit /usr/share/phpmyadmin/config.inc.php

#
#	Set up the default doc root
#
cd tmp
wget http://vhost-indexer.googlecode.com/files/vhost-indexer_0.2.tar.gz
cd /var/www
chmod 775 html
chmod g+s html
chown apache:apache html
mkdir -p html/local
cd html
chmod 775 local
chmod g+s local
cd local
tar -zxf /tmp/vhost-indexer_0.2.tar.gz
rm -f LICENSE README
mv htaccess.sample .htaccess
vi .htaccess
echo "<?php print phpinfo(); ?>" > tell_me_about_php.php
chown $USER:apache ./*

#
#	Crank up Apache
#
/sbin/chkconfig --levels 235 httpd on
/etc/init.d/httpd restart

#
#	Set up local user area
#
su - $USER
svn co http://svn.different.com/projects/scripts/trunk/bin bin
svn co http://svn.different.com/projects/scripts/trunk/etc etc
cd /tmp
wget http://ansi-color.googlecode.com/files/ansi-color-0.6.tar.gz
cd ~/bin
tar -zxf /tmp/ansi-color-0.6.tar.gz
ln -sf ansi-color-0.6/color
cd ..
mv .bashrc .bashrc.orig
ln -sf bin/profile .bashrc
mkdir src tmp
ln -sf /var/www/html www

#
#	Set up Drupal src tree
#

#
#	Set up Drupal site
#
