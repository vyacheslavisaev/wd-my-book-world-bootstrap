#!/bin/bash

DISK_A=$1
DISK_B=$2

if [[ "$#" -eq 2 ]]; then
	# if you have the 2-disk model, run the following commands instead
	mdadm --create /dev/md0 --raid-devices=2 --level=raid1  --run --metadata=0.90 ${DISK_A}1 ${DISK_B}1
	mdadm --create /dev/md1 --raid-devices=2 --level=raid1  --run --metadata=0.90 ${DISK_A}2 ${DISK_B}2
	mdadm --create /dev/md2 --raid-devices=2 --level=raid1  --run --metadata=0.90 ${DISK_A}3 ${DISK_B}3
elif [[ "$#" -eq 1 ]]; then
	# if you have the 1-disk model, run the following commands
	mdadm --create /dev/md0 --raid-devices=2 --level=raid1 --run --metadata=0.90 ${DISK_A}1 missing
	mdadm --create /dev/md1 --raid-devices=2 --level=raid1 --run --metadata=0.90 ${DISK_A}2 missing
	mdadm --create /dev/md2 --raid-devices=2 --level=raid1 --run --metadata=0.90 ${DISK_A}3 missing
else
	echo " Provide 1 or 2 disks to create RAID."
fi
