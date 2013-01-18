#!/bin/bash

# Warning: make sure you don't have Adobe linux repository enabled.
# That stupid sh*t has some of the needed glibc libraries in it!
# Can cause problems.

function makelist {
	if [[ -z "$@" ]]
	then
		echo "syntax: makelist PACKAGE [PACKAGE ...]"
		echo "	e.g: makelist cpp gcc gcc-c++"
		echo "	e.g: makelist fpc"
		exit
	fi
	
	$HASH=/tmp/.makelist_HASH

	echo $@ | sed "s/ /\n/g" >> list
	cat list | sort | uniq | sponge list

	yum deplist `cat list` > deps
	cat deps | grep provider | awk {'print $2'} | cut -d'.' -f1 >> list
	cat list | sort | uniq | sponge list
	if [ `cat list | md5sum | awk {'print $1'}` == "`cat $HASH 2> /dev/null`" ]
	then
		exit
	else
		cat list | md5sum | awk {'print $1'} > $HASH
		makelist `cat list`
	fi
}

makelist $@
