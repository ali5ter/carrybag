#!/bin/sh
# @file dh_install_eaccellerator.sh
# @see http://www.hiveminds.co.uk/node/3202
# ----------------------------------------------------------------------------

# Abort on any errors
set -e

# Where do you want all this stuff built? I'd recommend picking a local
# filesystem.
# ***Don't pick a directory that already exists!***  We clean up after
# ourselves at the end!
SRCDIR=${HOME}/source

# And where should it be installed?
INSTALLDIR=${HOME}/php5/

# Set DISTDIR to somewhere persistent, if you plan to muck around with this
# script and run it several times!
DISTDIR=${HOME}/dist

# Pre-download clean up!!!!
rm -fr $SRCDIR $DISTDIR

# Update version information here.
AUTOCONF="autoconf-2.61"
AUTOMAKE="automake-1.9.6"
EAC="eaccelerator-0.9.5"

# What PHP features do you want enabled?
EACFEATURES="--prefix=${INSTALLDIR} \
--enable-eaccelerator=shared \
--with-php-config=$PHP_PREFIX/bin/php-config"



# ---- end of user-editable bits. Hopefully! ----

# Push the install dir's bin directory into the path
export PATH=${INSTALLDIR}/bin:$PATH

#setup directories
mkdir -p ${SRCDIR}
mkdir -p ${INSTALLDIR}
mkdir -p ${DISTDIR}
cd ${DISTDIR}

# Get all the required packages
wget -c http://ftp.gnu.org/gnu/autoconf/${AUTOCONF}.tar.gz
wget -c http://ftp.gnu.org/gnu/automake/${AUTOMAKE}.tar.gz
wget -c http://bart.eaccelerator.net/source/0.9.5/${EAC}.tar.bz2


echo ---------- Unpacking downloaded archives. This process may take several minutes! ----------

cd ${SRCDIR}
# Unpack them all
echo Extracting ${AUTOCONF}...
tar xzf ${DISTDIR}/${AUTOCONF}.tar.gz
echo Done.
echo Extracting ${AUTOMAKE}...
tar xzf ${DISTDIR}/${AUTOMAKE}.tar.gz
echo Done.
echo Extracting ${EAC}...
tar -xjf ${DISTDIR}/${EAC}.tar.bz2
echo Done.

export PATH=${SRCDIR}/bin:$PATH
export PHP_PREFIX=${INSTALLDIR}/bin


# Build them in the required order to satisfy dependencies.

#AUTOCONF
cd ${SRCDIR}/${AUTOCONF}
./configure --prefix=${SRCDIR}
# make clean
make
make install

#AUTOMAKE
cd ${SRCDIR}/${AUTOMAKE}
./configure --prefix=${SRCDIR}
# make clean
make
make install

#EAC
cd ${SRCDIR}/${EAC}
$PHP_PREFIX/phpize
./configure --enable-eaccelerator=shared  --with-eaccelerator-info --with-php-config=$PHP_PREFIX/php-config
# make clean
make


#copy config file
cp modules/eaccelerator.so  ${INSTALLDIR}/lib/php/extensions/eaccelerator.so
mkdir -p ~/tmp/eaccelerator


rm -fr $SRCDIR $DISTDIR

echo ---------- INSTALL COMPLETE! ----------