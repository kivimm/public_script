#!/bin/bash

if [ $# = 2]; then
	onedrive_dir=$1
	filename=$2
else
	onedrive_dir=/Downloads
	filename=$1
fi

echo "uploding $filename to ${onedrive_dir}"

if [ -d "$filename" ]; then
    /usr/local/bin/onedrive-d -f ${onedrive_dir} "$filename"
elif [ -f "$filename" ]; then
   /usr/local/bin/onedrive -f ${onedrive_dir} "$filename"
else
    echo "filename invalid."
fi

if [ $? -eq 0 ]; then
    echo "upload successed."
    rm -rf "$filename"
else
    echo "upload failed."
fi

