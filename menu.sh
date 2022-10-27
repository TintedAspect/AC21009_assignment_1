#!/bin/bash

. ./logger.sh
. ./filemanager.sh
. ./repomanager.sh
. ./archivemanager.sh

#decided to have different functions for levels of menus from the start to enable clarity if we move on to extensions
filemenu(){
	showfiles
	#may want to redesign this map with the file selection first, followed by modification options
	echo "Select from the following file management options:"
	select action in "Create file" "Delete file" "Check out/in file" "Edit checked out text file" "Restore previous state of checked out file" "Quit"
	do
		case ${action} in
			"Create file")
				createfile
				echo -e "1) Create file\n2) Delete file\n3) Check out/in file\n4) Edit checked out text file\n5) Restore previous state of checked out file\n6) Quit"
				;;
			"Delete file")
				deletefile
				echo -e "1) Create file\n2) Delete file\n3) Check out/in file\n4) Edit checked out text file\n5) Restore previous state of checked out file\n6) Quit"
				;;
			"Check out/in file")
				checkfile
				echo -e "1) Create file\n2) Delete file\n3) Check out/in file\n4) Edit checked out text file\n5) Restore previous state of checked out file\n6) Quit"
				;;
			"Edit checked out text file")
				editfile
				echo -e "1) Create file\n2) Delete file\n3) Check out/in file\n4) Edit checked out text file\n5) Restore previous state of checked out file\n6) Quit"
				;;
			"Restore previous state of checked out file")
				rollfile
				echo -e "1) Create file\n2) Delete file\n3) Check out/in file\n4) Edit checked out text file\n5) Restore previous state of checked out file\n6) Quit"
				;;
			"Quit")
				break
				;;
			*)
				echo "Invalid input, please try again."
				echo -e "1) Create file\n2) Delete file\n3) Check out/in file\n4) Edit checked out text file\n5) Restore previous state of checked out file\n6) Quit"
				;;
		esac
	done
}

repomenu(){
	echo "Select from the following repository management options:"
	select action in "Create a new repository" "Change active repository" "Quit"
	do
		case ${action} in
			"Create a new repository")
				createrepo
				echo -e "1) Create a new repository\n2) Change active repository\n3) Quit"
				;;
			"Change active repository")
				changerepo
				echo -e "1) Create a new repository\n2) Change active repository\n3) Quit"
				;;
			"Quit")
				break
				;;
			*)
				echo "Invalid input, please try again."
				echo -e "1) Create a new repository\n2) Change active repository\n3) Quit"
				;;
		esac
	done
}

archivemenu(){
	echo "Select from the following archival options:"
	select action in "Archive repository" "Restore repository from archive" "Quit"
	do
		case ${action} in
			"Archive a repository")
				archiverepo
				echo -e "1) Archive repository\n2) Restore repository from archive\n3) Quit"
				;;
			"Restore repository from archive")
				restorepo
				echo -e "1) Archive repository\n2) Restore repository from archive\n3) Quit"
				;;
			"Quit")
				break
				;;
			*)
				echo "Invalid input, please try again."
				echo -e "1) Archive repository\n2) Restore repository from archive\n3) Quit"
				;;
		esac
	done
}

logmenu(){
	echo "Select from the following log options:"
	select action in "View log of chosen file" "View full log" "Quit"
	do
		case ${action} in
			"View log of chosen file")
				viewfilelog
				echo -e "1) View log of chosen file\n2) View full log\n3) Quit"
				;;
			"View full log")
				viewlog
				echo -e "1) View log of chosen file\n2) View full log\n3) Quit"
				;;
			"Quit")
				break
				;;
			*)
				echo "Invalid input, please try again."
				echo -e "1) View log of chosen file\n2) View full log\n3) Quit"
				;;
		esac
	done
}

basemenu(){
	echo -e "Your currently selected repository is $activerepo.\n What would you like to do?"
	select action in "Manage files" "Configure repository" "View archiving options" "Manage logs" "Quit"
	do
		case ${action} in
			"Manage files")
				filemenu
				echo "Returning to top menu."
				echo -e "1) Manage files\n2) Configure repository\n3) View archiving options\n4) Manage logs\n5) Quit"
				;;
			"Configure repository")
				repomenu
				echo "Returning to top menu."
				echo -e "1) Manage files\n2) Configure repository\n3) View archiving options\n4) Manage logs\n5) Quit"
				;;
			"View archiving options")
				archivemenu
				echo "Returning to top menu."
				echo -e "1) Manage files\n2) Configure repository\n3) View archiving options\n4) Manage logs\n5) Quit"
				;;
			"Manage logs")
				logmenu
				echo "Returning to top menu."
				echo -e "1) Manage files\n2) Configure repository\n3) View archiving options\n4) Manage logs\n5) Quit"
				;;
			"Quit")
				break
				;;
			*)
				echo "Invalid input, please try again."
				echo -e "1) Manage files\n2) Configure repository\n3) View archiving options\n4) Manage logs\n5) Quit"
				;;
		esac
	done
}

basemenu