#!/bin/bash

IFS=$'\n'

Count=0

#Delete extend attr Finderinfo
DelExtAttr() {

	FileList=$(ls $1)

	for file_name in $FileList
	do
		if [ -d $1"/"$file_name ] 
		then
			DelExtAttr $1"/"$file_name
		else
			xattr -w com.apple.FinderInfo "00000000000000000010000000000000" $1"/"$file_name

			Count=$((Count+1))
		fi		
	done
}

VolumePath="/Volumes"

DirList=$(ls $VolumePath)

for dir in $DirList
do
	dir_name=$(expr "$dir" : '\(Test.*\)')

	if [ "${dir_name}" != "" ]
	then
		DelExtAttr $VolumePath"/"$dir_name
	fi
done

echo Total $Count files processed!!!
