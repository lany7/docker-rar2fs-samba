#!/bin/bash

service samba start

rar2fs -f --exclude=".wd_tv" --seek-length=1 "${1}" "${2}"
