#!/bin/bash

#checks if the variable activerepo has a value, if it doesn't it sets it to match the address stored in the file activerepo.txt and also initialises that if it doesn't exist
checkactiverepo(){
	if [[ -n $(wc activerepo.txt) && -d $(cat activerepo.txt) ]]
	then
		activerepo=$(cat activerepo.txt)
	else
		activerepo=$PWD
		echo $PWD > activerepo.txt
	fi
}


createrepo(){
	read -p "Please enter the name of the repository you'd like to create:" rname
	read -p "Please enter the path to where you'd like to create this repository:" rpath
	if [[ -d $rpath && ! -d "$rpath/$rname" ]]
	then
		( cd $rpath ; mkdir $rname ; cd $rname ; touch log.txt )
		echo -e "$(cd $rpath/$rname ; pwd)\n" >> repolist.txt				#subshell used to allow relative paths to always be logged properly
		echo "Successfully created repository $rname at $rpath."
	elif [[ -d "$rpath/$rname" ]]
	then
		read -p "$rpath/$rname already exists, would you like to make the currently existing directory into a repository? (y/n)" ans
		case $ans in
			(y | Y) 
				( cd $rpath/$rname ; touch log.txt )
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
	fi
}

changerepo(){
	echo "The current active repository is $activerepo. Please select the new active repository from the following list."
	if [ ! -f repolist.txt ]
	then
		echo -e "$activerepo\n" >> repolist.txt
	fi
	local i="1"
	while [ $i -lt $(wc -l < repolist.txt) ]
	do
		repo[i]="$(cat repolist.txt | head -$i | tail -1)"
		((i++))
	done
	select act in "${repo[@]}"
	do
		case $act in
			"${repo[@]}")
				activerepo=${repo[@]}
				echo "The active repository is now $activerepo."
				echo $activerepo > activerepo.txt
				break
				;;
			*)
				echo "Invalid input"
				break
				;;
		esac
	done
}