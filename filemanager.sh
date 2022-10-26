#!/bin/bash

. ./repomanager.sh
. ./logger.sh

#while loop to print all files ordered by time modified alongside their logout value
showfiles(){
	echo "These are the files in the selected repository by date modified with their logout status:"
	i="1"
	while [ $i -lt $[$(ls -1q $activerepo | wc -l)+1] ]
	do
		echo -n $[$i]") " $(ls -1qt | head -$i | tail -1)" - "
		if [ -z "${logged[$i]}" ]
		then
			logged[$i]=0
			echo -n "not "
		fi
		echo "logged out."
		i=$[$i+1]
	done
}

createfile(){

}

#made instead of just using rm in menu to allow for future configuration regarding permissions in repo without requiring rewrites
deletefile(){

}

logfile(){

}

editfile(){

}

rollfile(){}