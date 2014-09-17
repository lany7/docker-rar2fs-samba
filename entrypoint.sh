#!/bin/bash

service samba start

rar2fs -d -f "${1}" "${2}"
