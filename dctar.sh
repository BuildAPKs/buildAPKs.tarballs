#!/bin/env sh
# Copyright 2019 (c) all rights reserved by S D Rausty; see LICENSE  
# https://sdrausty.github.io hosted courtesy https://pages.github.com
# deletes corrupt *.tar.gz files 
#####################################################################
set -eu

_PTGS_ () { # proccess *.tar.gz files for errors
	for FNAME in $LTYPE
	do 
		if ! tar tf "$FNAME" 1>/dev/null 
		then 
			rm -f "$FNAME" 
		fi
	done
}

_PRINTCPF_ () {
	printf "%s\\n" "Cannot process *.tar.gz files!"  
}

_PRINTDONE_ () {
	printf "DONE\\n"
	printf "\033]2;%sDONE\007" "Processing *.tar.gz files: "
}

_PRINTPTF_ () {
	printf "%s" "Processing *.tar.gz files: "
	printf "\033]2;%sOK\007" "Processing *.tar.gz files: "
}

_PRINTD_ () {
	printf "\\n%s\\n" "Invalid option; Options for ${0##*/} file are:"
	grep -w "elif \[" "$0" | awk '{print $5}'
}

_PRINTPTF_ 
if [ -z "${1:-}" ]
then
	_PRINTD_ 
elif [ $1 = 0 ] 
then
	if [ ${PWD##*/} = "buildAPKs.tarballs" ]
	then
		FLIST="CHANGE.log LICENSE README.md *.sh *.bash *.zip"
		mkdir -p $TMPDIR/buildAPKs.tarballs.$$
		for i in $FLIST
		do
			cp $i $TMPDIR/buildAPKs.tarballs.$$ 
		done
		LTYPE="$(ls)" || _PRINTCPF_ 
  		_PTGS_
		cp $TMPDIR/buildAPKs.tarballs.$$/* . 
 		rm -rf $TMPDIR/buildAPKs.tarballs.$$
	else
		_PRINTCPF_ 
	fi
elif [ $1 = ls ] 
then
	LTYPE="$(ls *.tar.gz)" || _PRINTCPF_ 
	_PTGS_
elif [ $1 = lsf ] 
then
	LTYPE="$(ls -d -1 ./**/*.tar.gz)" || _PRINTCPF_ 
	_PTGS_
elif [ $1 = find ] 
then
	LTYPE="$(find . -type f -name "*.tar.gz")" || _PRINTCPF_ 
	_PTGS_
elif [ $1 = find1 ] 
then
	LTYPE="$(find . -maxdepth 1 -type f -name "*.tar.gz")" || _PRINTCPF_ 
	_PTGS_
fi
_PRINTDONE_ 
# dctar.sh EOF
