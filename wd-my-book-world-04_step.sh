#!/bin/bash

set -e

if [[ "$#" -ne 2 ]]; then
    echo "Disk and path to files are expected!"
fi

DISK=$1
SYS_PATH=$2

# write the MBR
perl <<EOF | dd of=${DISK} bs=512
    print "\x00" x 0x1a4;
    print "\xb2\x80\x00\x00";
    print "\xb2\x7d\x00\x00";
    print "\x00\x03\x00\x00";
    print "\x00" x (0x1b0 -0x1a4 -12 );
    print "\x24\x03\x00\x00";
    print "\x24\x00\x00\x00";
    print "\x00\x03\x00\x00";
EOF
# 2-disk owners, please run that command again changing /dev/sdX to /dev/sdY

# write the bootloader and whatnot
dd if=${SYS_PATH}/stage1.wrapped of=${DISK} bs=512 seek=36
dd if=${SYS_PATH}/u-boot.wrapped of=${DISK} bs=512 seek=38
dd if=${SYS_PATH}/uImage         of=${DISK} bs=512 seek=336
dd if=${SYS_PATH}/uImage.1       of=${DISK} bs=512 seek=8482
dd if=${SYS_PATH}/uUpgradeRootfs of=${DISK} bs=512 seek=16674
dd if=${SYS_PATH}/stage1.wrapped of=${DISK} bs=512 seek=32178
dd if=${SYS_PATH}/u-boot.wrapped of=${DISK} bs=512 seek=32180
dd if=${SYS_PATH}/uImage         of=${DISK} bs=512 seek=32478
# 2-disk owners, you know the drill: please run those commands agian, but this time of=/dev/sdY

# if you have the 1-disk model, run the following commands
mdadm --create /dev/md0 --raid-devices=2 --level=raid1 --run --metadata=0.90 ${DISK}1 missing
mdadm --create /dev/md1 --raid-devices=2 --level=raid1 --run --metadata=0.90 ${DISK}2 missing
mdadm --create /dev/md2 --raid-devices=2 --level=raid1 --run --metadata=0.90 ${DISK}3 missing

# if you have the 2-disk model, run the following commands instead
# mdadm --create /dev/md0 --raid-devices=2 --level=raid1  --run --metadata=0.90 /dev/sdX1 /dev/sdY1
# mdadm --create /dev/md1 --raid-devices=2 --level=raid1  --run --metadata=0.90 /dev/sdX2 /dev/sdY2
# mdadm --create /dev/md2 --raid-devices=2 --level=raid1  --run --metadata=0.90 /dev/sdX3 /dev/sdY3
