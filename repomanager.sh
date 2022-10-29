#!/bin/bash

#checks if the variable activerepo has a value, if it doesn't it sets it to match the address stored in the file activerepo.txt and also initialises that if it doesn't exist
checkactiverepo(){
	if [[ -n $(wc activerepo.txt) && -d $(cat activerepo.txt) ]]
	then
		activerepo=$(cat activerepo.txt)
	fi
}

#creates a repository, turns an existing directory into a repository or registers a currently existing repository in the system
createrepo(){
	read -p "Please enter the name of the repository you'd like to create:" rname
	read -p "Please enter the path to where you'd like to create this repository:" rpath
	if [[ -d $rpath && ! -d "$rpath/$rname" ]]
	then
		( cd $rpath ; mkdir $rname ; cd $rname ; mkdir repoinfo ; cd repoinfo ; touch log.txt )
		echo -e "$(cd $rpath/$rname ; pwd)\n" >> repolist.txt				#subshell used to allow relative paths to always be logged for absolute access
		echo "Successfully created repository $rname at $rpath."
	elif [[ -d "$rpath/$rname/repoinfo" ]]
	then
		echo "$rpath/$rname already exists and is already a repository."
		if [[ -z $(grep $rpath/$rname repolist.txt) ]]; then
			echo -e "$(cd $rpath/$rname ; pwd)\n" >> repolist.txt
			echo "Properly registered $rname as a repository."
		fi
	elif [[ -d "$rpath/$rname" ]]
	then
		read -p "$rpath/$rname already exists, would you like to make the currently existing directory into a repository? (y/n)" ans
		case $ans in
			(y | Y) 
				( cd $rpath/$rname ; mkdir repoinfo ; cd repoinfo ; touch log.txt ; mkdir backups )
				echo -e "$(cd $rpath/$rname ; pwd)\n" >> repolist.txt
				echo "Successfully turned directory $rname at $rpath into a repository."
				;;
			(n | N)
				;;	
			*)
				echo "Invalid input."
				;;
		esac
	else
		echo "That is not a correct path."
	fi
	if [[ $(wc -l repolist.txt) == 1 ]]
	then
		activerepo="$rpath/$rname"
		echo $activerepo > activerepo.txt
		echo "As there were no prior registered repositories, this new repository has been made active."
	fi
}

#creates an array of all registered repos
listrepos(){
	if [[ ! -f repolist.txt && -n $activerepo ]]
	then
		echo -e "$activerepo\n" >> repolist.txt
	fi
	local i="1"
	local j="0"
	repo=()
	while [[ $i -lt $[$(wc -l < repolist.txt)+1] ]]; do
		if [[ -n $(cat repolist.txt | head -$i | tail -1) ]]; then
			repo[j]=$(cat repolist.txt | head -$i | tail -1)
			((j++))
		fi
		((i++))
	done
}

#changes variable activerepo and updates current file stored value to match 
changerepo(){
	listrepos
	if [[ ${#repo[@]} ]]; then
		if [ -n $activerepo ]; then
			echo "The current active repository is $activerepo. Please select the new active repository from the following list."
		else
			echo "There is no current active repository. Please select a repository to make from the following list or create a new one."
		fi
		select act in "${repo[@]}" "Quit"; do
			if [[ "${repo[@]}" =~ "$act" ]]; then
				activerepo=$act
				echo "The active repository is now $activerepo."
				echo $activerepo > activerepo.txt
				break
			elif [[ "$act"="Quit" ]]; then
	    		break
			else
				echo "Invalid input, please try again."
			fi
		done
	else
		echo "There are currently no registered repositories. Please create a new repository, convert an existing directory to a repository or register a currently existing repository with the 'Create a new repository' option."
	fi
}

#deletes repo chosen from select menu
delrepo(){
	listrepos
	if [[ ${#repo[@]} ]]; then
		echo "Which repository would you like to delete?"
		select delr in "${repo[@]}" "Quit"; do
			if [[ "${repo[@]}" =~ "$delr" ]]; then
				if [[ "$activerepo"="$delr" ]]; then
					read -p "You are attempting to delete the currently active repository. Are you sure you want to do this? (y/n)" yn
					case $yn in
						Y | y)
						activerepo=
						echo > activerepo.txt
						;;
						N | n)
						echo "Aborting process."
						break
						;;
						*)
						echo "Invalid input. Aborting process."
						break
						;;
					esac
				fi
				grep -v "$delr" repolist.txt > temp ; mv temp repolist.txt
				rm -rf "$delr"
				break
			elif [[ "$delr"="Quit" ]];then
				break
			else 
				echo "Invalid input, please try again."
			fi
		done
	else
		echo "There are currently no registered repositories, and thus no repositories to delete."
	fi
}