#!/bin/bash

echo "\$#=$#"
echo "\$1=$1"

mount_dir=${HOME}/Desktop/Test


# Invalid input
if [ $# -ge 1 ]
then
	echo "Useage: ./ReMount"
	exit 1
fi


# Get device name automatically
TempStr=$(diskutil list | grep "Windows_NTFS")

device_name=${TempStr:0-7}

if [ -z $device_name ]
then
	echo "No NTFS Disk found!!!"
	exit 1
fi


echo "\$device_name = $device_name"


# Create mount dir in desktop
if [ ! -e ${mount_dir} ]
then
	mkdir ${HOME}/Desktop/Test
	echo "${HOME}/Desktop/Test has created"
else
	echo "${HOME}/Desktop/Test exist"
fi

# Unmount device 
sudo umount /dev/${device_name}


# Mounut device
echo "remounting..."

sudo mount -t ntfs -o rw,nobrowse /dev/${device_name} ${mount_dir}

#echo "\$?=$?"

if [ $? -eq 0 ]
then 	
	echo "Remount success!"
else
	echo "Remount failed!"
fi

