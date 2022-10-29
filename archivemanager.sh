#!/bin/bash

. ./repomanager.sh

#archives a file and creates a txt file with instructions to return it from whence it came
archiverepo(){
	echo "Please select which repository you would like to archive from the following list."
	listrepos
	select act in "${repo[@]}" "Quit"; do
		if [[ "${repo[@]}" =~ "$act" ]]; then
			if [ "$act" = "$activerepo" ]; then
				read -p "You are trying to archive the currently active repository. Do you wish to continue? (y/n)" n
				case $n in
					Y|y)
						activerepo=
						echo > activerepo.txt
						;;
					N|n)
						break
						;;
				esac
			fi
			if [[ ! -d archivedrepos ]]; then
				mkdir -p archivedrepos
			fi
			local tarn=$(basename $act)
			echo "$(dirname $act)" >> archivedrepos/$tarn.txt
    		tar -czvf archivedrepos/$tarn.tar.gz $(cd $act/../ ; basename $act)
    		grep -v "$act" repolist.txt > temp ; mv temp repolist.txt
    		rm -rf "$act"
    		echo "$act has been successfully archived"
    		break
    	elif [[ "$act"="Quit" ]]; then
    		break
		else
			echo "Invalid response, please try again."
		fi
	done
}

#restores a repository to a previous state that is backed up
restorepo(){
    local i=0
    local j=$i+1
    while [ $i -lt $(cd archivedrepos ; ls -1 *.tar.gz | wc -l) ]; do
    	local j=$(($i+1))
    	tarlist[$i]=$(cd archivedrepos ; ls -1 *.tar.gz | head -$j | tail -1)
    	((i++))
    done
    echo "Please select which archived repository you wish to restore:"
    select targ in "${tarlist[@]}" "Quit"; do
    	if [[ "${tarlist[@]}" =~ "$targ" ]]; then
    		local path=$(cat ${targ%.tar.gz}.txt)
    		(cd archivedrepos ; tar -xf $targ -C $path ; rm $targ ${targ%.tar.gz}.txt)
    		echo $path >> repolist.txt
    		break
    	elif [[ "$targ"="Quit" ]]; then
    		break
    	else
    		echo "Incorrect input, please try again."
    	fi
	done
}
