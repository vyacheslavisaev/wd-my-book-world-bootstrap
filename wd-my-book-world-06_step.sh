#!/bin/bash

set -e

## mkfs -t ext2 -L'boot' /dev/md0
## mkfs.ext3 -L'boot' /dev/md0

echo "Creating filesystem's"
echo
echo "Bootstrapping md0"
mkfs.ext3 /dev/md0

echo
echo "Bootstrapping md1"
mkswap /dev/md1

echo
echo "Bootstrapping md2"
mkfs.ext3 /dev/md2


#mkfs -t ext3 -L'boot' /dev/md0
#mkswap /dev/md1
#mkfs -t ext3 /dev/md2