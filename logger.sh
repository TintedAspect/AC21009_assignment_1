#!/bin/bash

. ./repomanager.sh
. ./backup.sh

#prints log to terminal
viewlog(){
	cat $activerepo/repoinfo/log.txt
}

#creates a new backup of the file and makes a log if its creation
createlog(){
	echo "$(date): $1 was created by $USER" >> $activerepo/repoinfo/log.txt
	backupfile $1
}

#prints all log entries making mention of $1 to terminal
checklog(){
	case "$2" in
	"0")
		echo "$(date): $1 was checked out by $USER" >> $activerepo/repoinfo/log.txt
		;;
	"1")
		read -p "Would you like to leave a message on what was edited? (y/n)" ans
		case "$ans" in
			(y | Y)
				read -p "Please enter message:" mess
				echo -n "$(date): $1 was checked in by $USER, message $mess" >> $activerepo/repoinfo/log.txt
				;;
			(n | N)
				echo -n "$(date): $1 was checked in by $USER" >> $activerepo/repoinfo/log.txt
				;;
			*)
				read -p "Invalid input. If you wish to leave a message, input it now, and if not, just press enter: " failans
				echo -n "$(date): $1 was checked in by $USER" >> $activerepo/repoinfo/log.txt
				if [ -n "$failans" ]; then
					echo -n ", message: $failans" >> $activerepo/repoinfo/log.txt
				fi
				;;
		esac
		echo ", changed $(diff -y --suppress-common-lines $activerepo/$1 $activerepo/repoinfo/backups/$(cd $activerepo/repoinfo/backups ; ls -t1 *$1 | head -1 | tail -1) | wc -l) lines" >> $activerepo/repoinfo/log.txt
		backupfile $1
		;;
	"7701")
		echo "$1 was checked back in."
		echo "$(date): $1 was checked in by $USER through system failsafe, changed $(diff -y --suppress-common-lines $activerepo/$1 $activerepo/repoinfo/backups/$(cd $activerepo/repoinfo/backups ; ls -t1 *$1 | head -1 | tail -1) | wc -l) lines" >> $activerepo/repoinfo/log.txt
		;;
	*)
		echo "Invalid input."
		;;
	esac
}