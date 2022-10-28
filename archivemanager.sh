#!/bin/bash

archiverepo(){
    mkdir -p Archived
    cp -r $activerepo Archived
    tar -czvf $activerepo.tar.gz Archived
    mv $activerepo.tar.gz Archived
    echo "File has been archived"
}

restorepo(){
    echo "File has been archived"
    read rName
    tar -xf Archived/$rName.tar.gz -C home/


}
