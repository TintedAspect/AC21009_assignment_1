#!/bin/bash

. ./repomanager.sh

#copies $1 to a backup file
backupfile(){
    cp $activerepo/$1 $activerepo/repoinfo/backups/$(date -uI"seconds")$1
}

#returns a file to a previously checked in state backed up within the system
restore(){
	local limit=$(cd $activerepo/repoinfo/backups ; ls -1 *$1 | wc -l)
	local i=1
	local filetores=()
	if [[ $limit -gt 0 ]]; then
		while [ "$i" -lt "$limit" ]; do
			filetores[$i]=$(cd $activerepo/repoinfo/backups ; ls -1 *$1 | head -$i | tail -1)
			((i++))
		done
		echo "Please select which backup you want to restore from:"
		select choice in "${filetores[@]}" "Quit"; do
			if [[ "${filetores[@]}" =~ "$choice" ]]; then
				cp $activerepo/repoinfo/backups/${filetores[$REPLY]} $activerepo/$1
				echo "$1 has successfully been restored from ${filetores[$REPLY]}."
				break
			elif [[ "$choice"="Quit" ]]; then
    			break
			else
				echo "Invalid input, please try again."
			fi
		done
	else
		echo "This file has no backups."
	fi
	
}