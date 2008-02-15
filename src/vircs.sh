#!/bin/sh
# $Id: vircs,v 1.1 2007/08/15 17:13:29 abowen Exp $

CO=co;
CI=ci;
EDITOR=vi;

$CO -l $1;
$EDITOR $1;
$CI $1;
$CO $1;
