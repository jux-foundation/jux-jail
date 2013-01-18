#!/bin/bash

set -e

function get_repo_online {
	yum reinstall -y --downloadonly --downloaddir=repo `cat list`
}

function get_repo_dvd {
	mkdir repo
	for i in `cat list`
	do
		package=`find iso | grep $i | cut -d'/' -f4 | grep ^$i-[1234567890]`
		cp iso/Packages/*/$i repo
	done
}

function makejail {
	get_repo_$method

	mkdir root
	cd root

	for i in `ls ../repo`
	do
		rpm2cpio ../repo/$i | cpio -idm
	done

	echo "Removing a couple of files that are useless for all intents and purposes of a jail ..."
	rm -rf usr/lib/locale usr/share/{cracklib,doc,i18n,info,locale,man,zoneinfo}

	echo "Starting to reset SELinux contexts of the chroot environment ..."
	setfiles -p -r . /etc/selinux/targeted/contexts/files/file_contexts .

	cd ..
	echo "done"
}


if [ ! -e list ]
then
	echo "Run \`make list\` first."
	exit
fi

echo "
Two sources for the required packages are available:

  1. Online Fedora repositories (default) (Internet required, ~65MB will be downloaded)
       tip: if you want to use local repositories, follow the steps required to add them
            to yum repositories at /etc/yum.repos.d/

  2. Use an already downloaded Fedora iso or mounted DVD (arch doesn't matter).
"

read -p "Which method? (1/2) (default: 1) " ask

if [[ "$ask" == *2* && "$ask" != *1* ]]
then
	echo "DVD method chosen ..."
	method="dvd"
	read -p "Where is the DVD/iso mounted?" src
	if [ -d "$src" ]
	then
		if [ "$src" != "iso" ]
		then
			ln -s $i iso
		fi
	else
		echo "error: cannot access $src: No such directory"
		exit
	fi
elif [[ "$ask" == *2* && "$ask" == *1* ]]
then
	echo "error: couldn't detect your choice (contained both '1' and '2')"
else
	echo "Online method chosen ..."
	method="online"
fi

makejail $method
