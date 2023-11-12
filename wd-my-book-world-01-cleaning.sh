#/bin/bash

set -e

if [[ "$#" -le 1 ]]; then
    echo "Disk and md parts are expected!"
    exit 1
fi

disk=$1

mds=${@:2}

disk_id=1
for md in $mds; do

mdadm --stop /dev/${md}

mdadm --fail /dev/${md} ${disk}${disk_id}

mdadm --remove /dev/${md} ${disk}${disk_id}

disk_id=$((disk_id++))
done
