#!/bin/bash

echo "\$#=$#"
echo "\$1=$1"

mount_dir=${HOME}/Desktop/Test

# Use default device name
if [ $# -eq 0 ]
then
	read -r -p "Do you want to use default device name(disk2s1) ? [Y/n] " iskill
	case $iskill in
    	[yY][eE][sS]|[yY])
		echo "Yes"
		device_name="disk2s1"
		break
		;;
 
    	[nN][oO]|[nN])
		echo "No"
		exit 0
       		;;
 
    	*)
		echo "Invalid input..."
		exit 1
		;;
	esac
fi

# Use $1 as device name
if [ $# -eq 1]
then
	device_name=$1
fi

# Invalid input
if [ $# -gt 1 ]
then
	echo "Useage: ReMount/ReMount device_name(diskutil list)"
	exit 1
fi

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

