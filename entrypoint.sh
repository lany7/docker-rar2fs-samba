#!/bin/bash

service samba start

rar2fs -f "${1}" "${2}"
