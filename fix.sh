#!/usr/bin/env bash

if  [ -f "./patches/$1.patch" ]; then
    git -C linux apply "../patches/$1.patch" 2>> stderr.log
fi

echo "$1" | grep -E "3\.." > /dev/null
if [ $? -eq 0 ]; then 
    sed -i 's/default 7.10.d/default "7.10.d"/' linux/arch/microblaze/platform/generic/Kconfig.auto
    exit 0
fi

echo "$1" | grep -E "4\.." > /dev/null
if [ $? -eq 0 ]; then 
    sed -i 's/default 7.10.d/default "7.10.d"/' linux/arch/microblaze/Kconfig.platform
    exit 0
fi