
#!/bin/bash

# Author: Rishabh Bohra <rishabhbohra01@gmail.com>

# This script takes two template files of any service and shows the diff 
# between these after doing some cleanups
# For example
# If we provide server.properties file of Apache Kafka with params 
#
# ##############server.properties#############################
# log.dirs= ~/temp
# num.partitions={{ .Params.NUM_PARTITIONS }}
# ############################################################
#
# this script will process the file to something like
#
# #############source.log#####################################
# log.dirs
# num.partitions
# ############################################################
# USAGE:
# This script should be used to check difference of parameters between 
# two similar files to check if some parameters are missing or extra 
# between the two.
# #############################################################


TEMP_FOLDER="diff-checker"
# help
help() {
  cli_name=${0##*/}
  echo "
$cli_name

Usage: ./$cli_name show [file1_path] [file2_path]
Commands:
show [file_1] [file_2] Show diff
help,-h                 Help
"
  exit 1
}

# checks if file is present
checkFile() {
	FILE=$1
	if [ -f "$FILE" ]; then
	    echo "$FILE exists."
	else 
	    echo "Unable to locate file $FILE. Try again with correct path."
	    exit 1
	fi
	
}

# shows the diff after file processing
showDiff() {
	checkFile $1
	checkFile $2
	local loadSource=$1
	local loadTarget=$2
	local source=$TEMP_FOLDER/source.log && touch $source
	local target=$TEMP_FOLDER/target.log && touch $target
	rm -rf $TEMP_FOLDER
	mkdir $TEMP_FOLDER
	cat "$loadSource" |  awk -F'[:#={{]' '!/^{{/ && length($1) > 0 { split($1, a, " "); print a[1] }' | awk /./ | sort >>$source
	cat "$loadTarget" |  awk -F'[:#={{]' '!/^{{/ && length($1) > 0 { split($1, a, " "); print a[1] }' | awk /./ | sort >>$target
	git diff --color $source $target
	
}

case $1 in
	show)
		sourceTemplate=$2
		targetTemplate=$3
		showDiff $2 $3
		;;
	*)
		help
		;;
esac
