#!/bin/bash

filename=$1
echo "uploding $filename"

if [ -d "$filename" ]; then
    /usr/local/bin/onedrive-d -f /Videos "$filename"
elif [ -f "$filename" ]; then
   /usr/local/bin/onedrive -f /Videos "$filename"
else
    echo "filename invalid."
fi

if [ $? -eq 0 ]; then
    echo "upload successed."
    rm -rf "$filename"
else
    echo "upload failed."
fi

