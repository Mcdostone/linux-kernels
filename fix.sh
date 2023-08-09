#!/usr/bin/env bash

ROOT="$(dirname $(realpath $0))"

if  [ -f "./patches/$1.patch" ]; then
    if  [ ! "./kernels/current/.git" ]; then
        git -C kernels/current restore .
        git -C kernels/current clean -fd
        git -C kernels/current apply "$ROOT/patches/$1.patch" 2>> stderr.loggit 
    else 
        patch -s -d kernels/current -p1 < "$ROOT/patches/$1.patch"
    fi
fi
