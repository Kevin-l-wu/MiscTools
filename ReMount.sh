#!/bin/bash

# for divided as '\n'
IFS=$'\n\n'

disk_list=$(diskutil list)

mount_dir_index=0


# Do remount core function 
DoRemount(){
	device_name=$1

	mount_dir_index=$2

	mount_dir=${HOME}/Desktop/Test"$mount_dir_index"

	echo "$mount_dir"

	# Create mount dir in desktop
	if [ ! -e ${mount_dir} ]
	then
		mkdir -p "$mount_dir"
		echo "$mount_dir"" has created"
	else
		echo "$mount_dir"" exist"
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
}

# Find out all external disks
disk_name_list=$(echo "$disk_list" | grep "external, physical")


if [ "$disk_name_list" = "" ]
then
	echo "No external device found!!!"
	exit 1
fi

for disk_name in $disk_name_list
do
	# Get external disk name, such as:disk2
	disk_name=$(expr "$disk_name" : '.*\(disk.\).*')
	
	# Get all describe string of a disk
	disk_str=$(expr "$disk_list" : '.*\(/dev/'"$disk_name"'.*'"${disk_name}"'s.\).*$')

	
	# Get all partition of a disk
	partition_list=$(echo "$disk_str" | grep "Windows_NTFS")
		
		
	for partition_name in {$partition_list}
	do	
		# Get partition identifier, such as: disk2s1
		partition_name=$(expr "$partition_name" : '.*\('"$disk_name"'s.\).*')
		
		
		if [ "$partition_name" != "" ]
		then

			mount_dir_index=$((mount_dir_index+1))

			DoRemount "$partition_name" "$mount_dir_index"

		fi			
	done
done

