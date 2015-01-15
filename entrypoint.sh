#!/bin/bash

service samba start

rar2fs -f --exclude=".wd_tv" "${1}" "${2}"
