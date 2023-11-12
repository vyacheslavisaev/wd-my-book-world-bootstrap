#/bin/bash

set -e

if [[ "$#" -ne 1 ]]; then
    echo "Only disk is expected!"
    exit 1
fi

disk=$1

# clear out any old boot information that already exists on the hard drive - this will wipe the hard drive!
dd if=/dev/zero of=${disk} bs=1M count=100

echo "2-disk owners, please now run the same command on /dev/sdY"
