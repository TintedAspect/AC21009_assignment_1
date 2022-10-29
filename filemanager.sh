#!/bin/bash

. ./repomanager.sh
. ./logger.sh
. ./backup.sh

#gives the $1th file within the directory $2, ignoring all directories
searchfile(){
	local i=$(($1+1))
	ls -pq $2 | grep -v /$ | head -$i | tail -1
}

#while loop to print all files alongside their checkout value
showfiles(){
	echo "These are the files in the selected repository with their checkout status:"
	local i="0"
	while [ $i -lt $(ls -pq $activerepo | grep -v /$ | wc -l) ]; do
		fnames[$i]=$(searchfile $i $activerepo)
		echo -n $(($i+1))") ${fnames[$i]} - "
		if [[ -z "${checked[$i]}" || "${checked[$i]}" -eq 0 ]]; then
			checked[$i]=0
			echo "not checked out."
		else
			echo "checked out by ${checkuser[$i]}."
		fi
		((i++))
	done
}

#creates a file in the repository, initialising its associated checkout variable
createfile(){
	read -p  "Please enter the name and file extension of the file you wish to create (for example, default.txt)" fname
	if [[ -e "$activerepo"/"$fname" ]]; then
		echo "$fname already exists."
	else
		(cd $activerepo ; touch $fname)
		local i=0
		local fnum
		while [ $i -lt $(ls -pq $activerepo | grep -v /$ | wc -l) ]; do
			if [[ -z "${fnames[$i]}" ]]; then
				fnum=$i
				break
			fi
			((i++))
		done
		checked[$fnum]=0
		fnames[$fnum]=$(searchfile $fnum $activerepo)
		createlog $fname
		echo "$fname was successfully created."
		read -p  "Would you like to check out $fname? (y/n)" ans
		case $ans in
			Y | y)
			echo "You have checked out $fname, enabling you to edit or delete it."
			checked[$fnum]=1
			checkuser[$fnum]=$USER
			checklog ${fnames[$fnum]} 0
			;;
			N | n)
			;;
			*)
			echo "Invalid input, not checking out $fname."
			;;
		esac
	fi
}

#makes an array of files that are accessible to the current user (only checked out files without arg, all files not checked out by another user with arg of 1)
arraccfiles(){
	local i=0
	local j=0
	accarr=()
	accfnum=()
	while [ $i -lt $(ls -pq $activerepo | grep -v /$ | wc -l) ]; do
		if [[ "${checked[$i]}" -eq 1 && "${checkuser[$i]}"=$USER ]]; then
			accarr[$j]=${fnames[$i]}
			accfnum[$j]=$i
			((j++))
		elif [[ "${checked[$i]}" -eq 0 && "$1" -eq 1 ]]; then
			accarr[$j]=${fnames[$i]}
			accfnum[$j]=$i
			((j++))
		fi
		((i++))
	done
}

#made instead of just using rm in menu to allow for future configuration, both regarding clearing associated global variables used to keep track of permissions in repo without requiring rewrites
deletefile(){
	arraccfiles
	if (( ${#accarr[@]} )); then
		echo "These are the files you currently have checked out and therefore can delete:"
		select delf in "${accarr[@]}" "Quit"; do
			if [[ "${accarr[@]}" =~ "$delf" ]]; then
				rm $activerepo/"$delf"
				echo "$delf has been deleted."
				local i=${accfnum[(($REPLY-1))]}
				fnames[$i]=
				checked[$i]=0
				checkuser[$i]=
				break
			elif [[ "$delf"="Quit" ]]; then
    			break
			else
				echo "invalid input"
				break
			fi
		done
	else
		echo "You do not have any files checked out."
	fi
}

#checks in and out files
#when a file is checked out the user is associatively stored until it is checked back in to prevent access from other users
checkfile(){
	arraccfiles 1
	if (( ${#accarr[@]} )); then
		echo "You can check in or out the following files:"
		select checkf in "${accarr[@]}" "Quit"; do
			if [[ "${accarr[@]}" =~ "$checkf" ]]; then
				local i=${accfnum[(($REPLY-1))]}
				case ${checked[$i]} in
					"0")
					echo "You have checked out ${fnames[$i]}, enabling you to edit or delete it."
					checked[$i]=1
					checkuser[$i]=$USER
					checklog ${fnames[$i]} 0
					;;
					"1")
					checked[$i]=0
					checklog ${fnames[$i]} 1
					checkuser[$i]=
					echo "You have checked in ${fnames[$i]}."
					;;
				esac
				break
			elif [[ "$checkf"="Quit" ]]; then
    			break
			else
				echo "Invalid input, please try again."
			fi
		done
	else
		echo "You currently cannot check in or out any files."
	fi
}

#opens a checked out file in nano and prompts the user to check it in after they have finished
editfile(){
	arraccfiles
	if (( ${#accarr[@]} )); then
		echo "These are the files you currently have checked out and therefore can edit:"
		select edfile in "${accarr[@]}" "Quit"; do
			if [[ "${accarr[@]}" =~ $edfile ]]; then
				local i=${accfnum[(($REPLY-1))]}
				nano $activerepo/$edfile
				read -p "Would you like to check in $edfile? (y/n)" yn
				case $yn in
					Y | y)
						checked[$i]=0
						checkuser[$i]=
						checklog $edfile 1
						echo "You have checked in $edfile."
						break
						;;
					N | n)
						break
						;;
					*)
						echo "Invalid input, please try again."
						;;
				esac
				break
			elif [[ "$edfile"="Quit" ]]; then
    			break
			else
				echo "Invalid input, please try again."
			fi
		done
	else
		echo "You do not have any files checked out."
	fi
}

#allows the user to rollback a file to one of several backups
rollfile(){
	arraccfiles
	if (( ${#accarr[@]} )); then
		echo "Please select which file you have checked out that you want to rollback:"
		select resfile in "${accarr[@]}" "Quit"; do
			if [[ "${accarr[@]}" =~ "$resfile" ]]; then
				restore "$resfile"
				break
			elif [[ "$resfile"="Quit" ]]; then
    			break
			else
				echo "Invalid input, please try again."
			fi
		done
	else
		echo "You do not have any files checked out."
	fi
}

#failsafe to ensure all files are checked back in on exiting the file menu
checkinall(){
	local i=0
	while [[ $i -lt $(ls -pq $activerepo | grep -v /$ | wc -l) ]]; do
		if [[ ${checked[$i]} -eq 1 ]]; then
			checked[$i]=0
			checklog ${fnames[$i]} "7701"
			fnames[$i]=
		fi
		((i++))
	done
}

#
viewfilelog(){
	echo "Which file's log would you like to view?"
	select flog in "${fnames[@]}"; do
		if [[ "${fnames[@]}" =~ "$flog" ]]; then
			grep ${fnames[$(($REPLY-1))]} $activerepo/repoinfo/log.txt
			break
		elif [[ "$flog"="Quit" ]]; then
    		break
		else
			echo "Invalid input, please try again."
		fi
	done
}