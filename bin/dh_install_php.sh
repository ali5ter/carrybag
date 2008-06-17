#!/bin/sh
# @file dh_install_php.sh
# @see http://www.hiveminds.co.uk/node/3201
# ----------------------------------------------------------------------------

# Abort on any errors
set -e

# The domain in which to install the PHP CGI script.
export DOMAIN="iic.different.com"

# Where do you want all this stuff built? I'd recommend picking a local
# filesystem.
# ***Don't pick a directory that already exists!***  We clean up after
# ourselves at the end!
SRCDIR=${HOME}/php_source

# And where should it be installed?
INSTALLDIR=${HOME}/php5

# Set DISTDIR to somewhere persistent, if you plan to muck around with this
# script and run it several times!
DISTDIR=${HOME}/dist

# Pre-download clean up!!!!
rm -fr $SRCDIR $DISTDIR

# Update version information here.
PHP5="php-5.2.6"
LIBICONV="libiconv-1.11"
LIBMCRYPT="libmcrypt-2.5.7"
LIBXML2="libxml2-2.6.27"
LIBXSLT="libxslt-1.1.18"
MHASH="mhash-0.9.7.1"
ZLIB="zlib-1.2.3"
CURL="curl-7.14.0"
LIBIDN="libidn-0.6.8"
CCLIENT="imap-2004g"
CCLIENT_DIR="imap-2004g" # Another pest!
FREETYPE="freetype-2.2.1"

# What PHP features do you want enabled?
PHPFEATURES="--prefix=${INSTALLDIR} \
 --with-config-file-path=${INSTALLDIR}/etc/php5/${DOMAIN} \
 --enable-force-cgi-redirect \
 --with-xml \
 --with-libxml-dir=${INSTALLDIR} \
 --with-freetype-dir=${INSTALLDIR} \
 --enable-soap \
 --with-openssl=/usr \
 --with-mhash=${INSTALLDIR} \
 --with-mcrypt=${INSTALLDIR} \
 --with-zlib-dir=${INSTALLDIR} \
 --enable-fastcgi \
 --with-jpeg-dir=/usr \
 --with-png-dir=/usr \
 --with-gd \
 --enable-gd-native-ttf \
 --enable-memory-limit
 --enable-ftp \
 --with-exif \
 --enable-sockets \
 --enable-wddx \
 --with-iconv=${INSTALLDIR} \
 --enable-sqlite-utf8 \
 --enable-calendar \
 --with-curl=${INSTALLDIR} \
 --enable-mbstring \
 --enable-mbregex \
 --with-mysql=/usr \
 --with-mysqli \
 --without-pear \
 --with-gettext \
 --with-imap=${INSTALLDIR} \
 --with-imap-ssl=/usr"

# ---- end of user-editable bits. Hopefully! ----

# Push the install dir's bin directory into the path
export PATH=${INSTALLDIR}/bin:$PATH

#setup directories
mkdir -p ${SRCDIR}
mkdir -p ${INSTALLDIR}
mkdir -p ${DISTDIR}
cd ${DISTDIR}

# Get all the required packages
#wget -c http://us3.php.net/distributions/${PHP5}.tar.gz
wget -c http://us3.php.net/get/${PHP5}.tar.gz/from/this/mirror
wget -c http://mirrors.usc.edu/pub/gnu/libiconv/${LIBICONV}.tar.gz
wget -c http://easynews.dl.sourceforge.net/sourceforge/mcrypt/libmcrypt-2.5.7.tar.gz
wget -c ftp://xmlsoft.org/libxml2/${LIBXML2}.tar.gz
wget -c ftp://xmlsoft.org/libxml2/${LIBXSLT}.tar.gz
wget -c http://superb-west.dl.sourceforge.net/sourceforge/mhash/${MHASH}.tar.gz
wget -c http://www.zlib.net/${ZLIB}.tar.gz
wget -c http://curl.haxx.se/download/${CURL}.tar.gz
wget -c http://kent.dl.sourceforge.net/sourceforge/freetype/${FREETYPE}.tar.gz
wget -c ftp://alpha.gnu.org/pub/gnu/libidn/${LIBIDN}.tar.gz
wget -c ftp://ftp.cac.washington.edu/imap/old/${CCLIENT}.tar.Z

echo ---------- Unpacking downloaded archives. This process may take several minutes! ----------

cd ${SRCDIR}
# Unpack them all
echo Extracting ${PHP5}...
tar xzf ${DISTDIR}/${PHP5}.tar.gz
echo Done.
echo Extracting ${LIBICONV}...
tar xzf ${DISTDIR}/${LIBICONV}.tar.gz
echo Done.
echo Extracting ${LIBMCRYPT}...
tar xzf ${DISTDIR}/${LIBMCRYPT}.tar.gz
echo Done.
echo Extracting ${LIBXML2}...
tar xzf ${DISTDIR}/${LIBXML2}.tar.gz
echo Done.
echo Extracting ${LIBXSLT}...
tar xzf ${DISTDIR}/${LIBXSLT}.tar.gz
echo Done.
echo Extracting ${MHASH}...
tar xzf ${DISTDIR}/${MHASH}.tar.gz
echo Done.
echo Extracting ${ZLIB}...
tar xzf ${DISTDIR}/${ZLIB}.tar.gz
echo Done.
echo Extracting ${CURL}...
tar xzf ${DISTDIR}/${CURL}.tar.gz
echo Done.
echo Extracting ${LIBIDN}...
tar xzf ${DISTDIR}/${LIBIDN}.tar.gz
echo Done.
echo Extracting ${CCLIENT}...
uncompress -cd ${DISTDIR}/${CCLIENT}.tar.Z |tar x
echo Done.
echo Extracting ${FREETYPE}...
tar xzf ${DISTDIR}/${FREETYPE}.tar.gz
echo Done.

# Build them in the required order to satisfy dependencies.

#libiconv
cd ${SRCDIR}/${LIBICONV}
./configure --enable-extra-encodings --prefix=${INSTALLDIR}
# make clean
make
make install

#libxml2
cd ${SRCDIR}/${LIBXML2}
./configure --with-iconv=${INSTALLDIR} --prefix=${INSTALLDIR}
# make clean
make
make install

#libxslt
cd ${SRCDIR}/${LIBXSLT}
./configure --prefix=${INSTALLDIR} \
 --with-libxml-prefix=${INSTALLDIR} \
 --with-libxml-include-prefix=${INSTALLDIR}/include/ \
 --with-libxml-libs-prefix=${INSTALLDIR}/lib/
# make clean
make
make install

#zlib
cd ${SRCDIR}/${ZLIB}
./configure --shared --prefix=${INSTALLDIR}
# make clean
make
make install

#libmcrypt
cd ${SRCDIR}/${LIBMCRYPT}
./configure --disable-posix-threads --prefix=${INSTALLDIR}
# make clean
make
make install

#libmcrypt lltdl issue!!
cd  ${SRCDIR}/${LIBMCRYPT}/libltdl
./configure --prefix=${INSTALLDIR} --enable-ltdl-install
# make clean
make
make install

#mhash
cd ${SRCDIR}/${MHASH}
./configure --prefix=${INSTALLDIR}
# make clean
make
make install

#freetype
cd ${SRCDIR}/${FREETYPE}
./configure --prefix=${INSTALLDIR}
# make clean
make
make install

#libidn
cd ${SRCDIR}/${LIBIDN}
./configure --with-iconv-prefix=${INSTALLDIR} --prefix=${INSTALLDIR}
# make clean
make
make install

#cURL
cd ${SRCDIR}/${CURL}
./configure --with-ssl=${INSTALLDIR} --with-zlib=${INSTALLDIR} \
  --with-libidn=${INSTALLDIR} --enable-ipv6 --enable-cookies \
  --enable-crypto-auth --prefix=${INSTALLDIR}
# make clean
make
make install

# c-client
cd ${SRCDIR}/${CCLIENT_DIR}
make ldb
# Install targets are for wusses!
cp c-client/c-client.a ${INSTALLDIR}/lib/libc-client.a
cp c-client/*.h ${INSTALLDIR}/include

#PHP 5
cd ${SRCDIR}/${PHP5}
./configure ${PHPFEATURES}
# make clean
make
make install

#copy config file
mkdir -p ${INSTALLDIR}/etc/php5/${DOMAIN}
cp ${SRCDIR}/${PHP5}/php.ini-dist ${INSTALLDIR}/etc/php5/${DOMAIN}/php.ini

#copy PHP CGI and FCGI
mkdir -p ${HOME}/${DOMAIN}/cgi-bin
chmod 0755 ${HOME}/${DOMAIN}/cgi-bin
cp ${INSTALLDIR}/bin/php ${HOME}/${DOMAIN}/cgi-bin/php.cgi
cp ${INSTALLDIR}/bin/php ${HOME}/${DOMAIN}/cgi-bin/php5.fcgi
rm -fr $SRCDIR $DISTDIR

echo ---------- INSTALL COMPLETE! ----------