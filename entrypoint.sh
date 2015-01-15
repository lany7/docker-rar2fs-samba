#!/bin/bash

service samba start

rar2fs -f --exclude=/etc/rar2fs_exclude-file-filter "${1}" "${2}"
