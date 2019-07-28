#!/bin/bash

sync_dir=(
    "/home/kivim/workspace/netdisc/yuoo/files/Sync/别人的老婆 -照片、视频仓库" \
    "/home/kivim/workspace/netdisc/yuoo/files/Sync/最新电影" \
    "/home/kivim/workspace/netdisc/yuoo/files/Sync/得到 喜马拉雅 知乎 网易 樊登等知识付费栏目" \
    "/home/kivim/workspace/netdisc/yuoo/files/Sync/电子书支援计划精品书籍" \
    "/home/kivim/workspace/netdisc/yuoo/files/Sync/书格数字图书馆" \
    "/home/kivim/workspace/netdisc/yuoo/files/Sync/学习资料全集"
    )

rsync_exec()
{
    sync_root_dir="$1"
    archive_dir=${sync_root_dir}/.sync/Archive
    sync_cmd=/usr/bin/rsync

    if [[ ! -d "${archive_dir}" ]]; then
        echo "${archive_dir} not existed."
        return -1
    fi

    if [[ $(ls -A "${archive_dir}/") ]]; then
        echo "sync: ${archive_dir}/ to ${sync_root_dir}/"
        ${sync_cmd} -avuP "${archive_dir}/" "${sync_root_dir}/"
        
        if [[ $? -eq 0 ]]; then
            echo "delete: ${archive_dir}/*"
            rm -rf "${archive_dir}"/*
        else
            echo "rsync cmd exec failed."
        fi
        
        # echo "existed!"
    else
        echo "dir empty!"
    fi
}

# 获取当前目录下所有文件名称，包含目录名称
rsync_archive_current_dir_all()
{
    current_path="$PWD"

    for file_name in "${current_path}"/*; do
        if [ -d "${file_name}" ]; then
            echo "rsync dir: ${file_name}"
            rsync_exec "${file_name}"
        fi
    done
}

rsync_archive_dir_main()
{
    for (( i = 0; i < ${#sync_dir[@]}; i++ )); do
        echo "dir: ${sync_dir[i]}"
        rsync_exec "${sync_dir[i]}"
    done
}

rsync_archive_current_dir_all
