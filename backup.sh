#!/bin/bash

backupFile(){
    mkdir -p Backups
    cp $activerepo/$fName Backups
    echo "File has been backed up"
}

restore(){
    cp Backups/$fName $activerepo
    echo "File has been restored up"

}
