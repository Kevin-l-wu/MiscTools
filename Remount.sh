#!/bin/bash

# for divided as '\n'
IFS=$'\n\n'

disk_list=$(diskutil list)

mount_dir_index=0


# Check disk if mounted: mounted echo "Yes" otherwise ""
IsMounted() {

	device_name=$1

	info=$(diskutil info /dev/${device_name} | grep "Mounted")

	mounted=$(expr "$info" : '.*\(Yes\).*')

	echo $mounted
}


# Do remount core function 
DoRemount(){
	device_name=$1

	mount_dir_index=$2

#	mount_dir=${HOME}/Desktop/Test"$mount_dir_index"

	mount_dir=/Volumes/Test"$mount_dir_index"

	# Unmount device 
	echo "Checking if mounted"
	mounted=$(IsMounted "$device_name")

	if [ "$mounted" = "Yes" ]
	then
		sudo diskutil unmount /dev/${device_name}
	fi

	# Create mount dir in desktop
	if [ ! -e ${mount_dir} ]
	then
		sudo mkdir -p "$mount_dir"
		echo "$mount_dir"" has created"
	else
		echo "$mount_dir"" exist"
	fi

	# Mounut device
	echo "remounting..."

	sudo mount -t ntfs -o rw,nobrowse /dev/${device_name} ${mount_dir}


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

	
	# Get all partition of a disk as partition scheme type
	partition_scheme_type=$(echo "$disk_str" | grep "GUID_partition_scheme")

	if [ "$partition_scheme_type" != "" ]
	then
		type_str="Microsoft Basic Data"
	else
		type_str="Windows_NTFS"
	fi

	partition_list=$(echo "$disk_str" | grep "$type_str")
	
	if [ "$partition_list" = "" ]
	then
		echo "No NTFS partition found!!!"
		continue 1
	fi
		
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

	open /Volumes
done

