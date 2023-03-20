#!/bin/bash


IFS=','

#TestPath="/Volumes/未命名卷宗"
#TestPath="/Users/kevin/Desktop/Test/Test1"

Count=0

#
DelExtAttr() {

	FileList=$(ls -m $1)

#	echo $FileList

	for file in $FileList
	do
		file_name=$(expr "$file" : '^ *\(.*\)')

		if [ -d $1"/"$file_name ] 
		then
			#echo $1"/"$file
			DelExtAttr $1"/"$file_name
		else
			#echo "delte addr: "$1"/"$file_name
			xattr -w com.apple.FinderInfo "00000000000000000010000000000000" $1"/"$file_name

			Count=$((Count+1))
		fi		
	done
}

#DelExtAttr $TestPath


VolumePath="/Volumes"

#VolumePath="//Users/kevin/Desktop/Test"



DirList=$(ls -m $VolumePath)

for dir in $DirList
do
	dir_name=$(expr "$dir" : '.*\(Test.*\)')

	if [ "${dir_name}" != "" ]
	then
#		echo $dir_name
		DelExtAttr $VolumePath"/"$dir_name
	fi
done

echo Total $Count files processed!!!
