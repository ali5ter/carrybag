#!/bin/sh
# @file
# Embedded RCS when editing a file
# @author Alister Lewis-Bowen (alister@different.com)

CO=co;
CI=ci;
EDITOR=vi;

if [ ! -e RCS ]; then 
	mkdir RCS;
fi

$CO -l $1;
$EDITOR $1;
$CI $1;
$CO $1;

exit 0;
