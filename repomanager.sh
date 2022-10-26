#!/bin/bash

activerepo=./

createrepo()
{
	echo Enter Repository Name
	read rName
	mkdir $rName
	echo Created $rName Repository


}

listrepos(){

}

changerepo(){
	echo "The current active repository is $activerepo. Please select the new active repository from the following list."
	listrepos
}
