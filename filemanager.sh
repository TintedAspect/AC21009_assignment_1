#!/bin/bash

. ./repomanager.sh
. ./logger.sh

#gives the $1th file within the directory $2 when files have been ordered by date modified
searchfile(){
	ls -1qt $2 | head -$1 | tail -1
}

#while loop to print all files ordered by time modified alongside their checkout value
showfiles(){
	echo "These are the files in the selected repository by date modified with their checkout status:"
	local i="1"
	while [ $i -lt $[$(ls -1q $activerepo | wc -l)+1] ]
	do
		echo -n $[$i]") "$(searchfile $i $activerepo)" - "
		if [ -z "${checked[$i]}" ]
		then
			checked[$i]=0
			echo -n "not "
		fi
		echo "checked out."
		i=$[$i+1]
	done
}

createfile(){
	read -p  "Please enter the name and file extension of the file you wish to create (for example, default.txt)" fname
	touch $fname
	echo "$fname was successfully created."
}

#made instead of just using rm in menu to allow for future configuration regarding permissions in repo without requiring rewrites
deletefile(){
	read -p "Which file would you like to delete? " fname
	rm $fname
	echo "$fname has been deleted."
}

checkfile(){
	read -p "Which file would you like to check in/out? " c
	case ${checked[$c]} in
		"0")
			echo "You have checked out "$(searchfile $c $activerepo)", enabling you to edit it."
			log $(searchfile $c $activerepo)
			;;
		"1")
			echo "You have checked in "$(searchfile $c $activerepo)"."
			log $(searchfile $c $activerepo)
			;;
		"")
			if [ -z $(searchfile $c $activerepo) ]
			then
				echo "You have attempted to check out a file which does not appear to exist within this repository."
			else
				echo "The checkout status of "$(searchfile $c $activerepo)" appears to be incorrectly set. Defaulting logout status to 'not checked out'."
				checked[$c]=0
			fi
			;;
		*)
			;;
	esac
}

editfile(){
	echo "Please select which file you'd like to edit out of the following list:"
	
}

rollfile(){

}