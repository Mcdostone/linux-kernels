#!/usr/bin/env bash

ROOT="$(dirname $(realpath $0))"

if  [ -f "./patches/$1.patch" ]; then
    if  [ "./kernels/current/.git" ]; then
        git -C kernels/current restore .
        git -C kernels/current clean -fd
        git -C kernels/current apply "$ROOT/patches/$1.patch" 2>> stderr.log 
    else 
        if grep -q 'für' "$ROOT/patches/$1.patch"; then
                git -C kernels/current init .
                git -C kernels/current add .
                git -C kernels/current commit -m "ok"
                git -C kernels/current apply "$ROOT/patches/$1.patch"
        else
            patch -s -d kernels/current -p1 --no-backup-if-mismatch < "$ROOT/patches/$1.patch"
        fi
    fi
fi
