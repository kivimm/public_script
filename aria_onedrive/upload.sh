#!/bin/bash

upload()
{
    if [ $# -eq 0 ]; then
        echo "usage: upload.sh [onedrive_dir] [local_file]"
        exit 1
    elif [ $# -eq 1 ]; then
        onedrive_dir=/Downloads
        filename="$1"
    else
        onedrive_dir="$1"
        filename="$2"
    fi

    # read -e -p " 是否删除本地文件 [y/n]:" is_delete
    echo "uploding $filename to ${onedrive_dir}"

    if [ -d "$filename" ]; then
        /usr/local/bin/onedrive-d -f "${onedrive_dir}" "$filename"
    elif [ -f "$filename" ]; then
       /usr/local/bin/onedrive -f "${onedrive_dir}" "$filename"
    else
        echo "filename invalid."
    fi

    if [ $? -eq 0 ]; then
        echo "upload successed."
        rm -rf "$filename"
        # if [ "$is_delete" = "y" ]; then
        #     rm -rf "$filename"
        # fi
    else
        echo "upload failed."
    fi
}

# 获取当前目录下所有文件名称，包含目录名称
upload_current_dir_all()
{
    current_path="$PWD"
    current_folder_name=`basename "$current_path"`
    echo "current dir: ${current_folder_name}"
    upload_dir="/Videos/${current_folder_name}"

    for file_name in "${current_path}"/*; do
        if [ -d "$file_name" ]; then
            file=`basename "$file_name"`
            echo "dir: $file"
            # echo "uploading dir:${file} to ${upload_dir}>>"
            upload "${upload_dir}" "${file_name}"
        elif [[ -f $file_name ]]; then
            file=`basename "$file_name"`
            echo "file: $file"
            if [ "${file}" != "`basename "$0"`" ]; then
                # echo "uploading file:${file} to ${upload_dir}>>"
                upload "${upload_dir}" "${file_name}"
            fi
        fi
    done
}

# 遍历当前目录及子目录所有文件
function ergodic(){
    dst_dir=${PWD}
    for file in `ls "$dst_dir"`
    do
        if [ -d "${dst_dir}/$file" ]
        then
            ergodic "${dst_dir}/$file"
        else
            local path="${dst_dir}/$file" 
            local name="$file"      
            local size=`du --max-depth=1 "$path" | awk '{print $1}'` 
            echo "$name"  "$size" "$path"
        fi
    done
}

if [ $# -eq 0 ]; then
    echo "upload current all files."
    upload_current_dir_all
elif [[ $# -eq 1 ]]; then
    folder_name=`basename "$PWD"`
    echo "current dir: ${folder_name}"
    upload_path="/Videos/${folder_name}"
    echo "upload file $1 to ${upload_path}"
    upload "${upload_path}" "$1"
elif [[ $# -eq 2 ]]; then
    echo "upload file $2 to $1"
    upload "$1" "$2"
fi

