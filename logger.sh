#!/bin/bash

. ./repomanager.sh

viewlog(){
	cat $activerepo/repoinfo/log
}

viewfilelog(){
	grep $1 $activerepo/repoinfo/log
}


checklog(){
	case "$2" in
	"0")
		echo "$(date): $1 was checked out by $USER" >> $activerepo/repoinfo/log
		;;
	"1")
		read -p "Would you like to leave a message on what was edited? (y/n)" ans
		case "$ans" in
		(y | Y)
			read -p "Please enter message:" mess
			echo "$(date): $1 was checked in by $USER, message $mess" >> $activerepo/repoinfo/log
			;;
		(n | N)
			echo "$(date): $1 was checked in by $USER" >> $activerepo/repoinfo/log
			;;
		*)
			read -p "Invalid input. If you wish to leave a message, input it now, and if not, just press enter: " failans
			echo -n "$(date): $1 was checked in by $USER" >> $activerepo/repoinfo/log
			if [ -n "$failans" ]
			then
				echo ", message: $failans" >> $activerepo/repoinfo/log
			else
				echo >> $activerepo/repoinfo/log
			fi
			;;
		esac
		;;
	*)
		echo "Invalid input."
		;;
	esac
}