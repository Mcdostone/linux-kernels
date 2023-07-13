#!/usr/bin/env bash

if  [ -f "./patches/$1.patch" ]; then
    git init kernels/$1
    git -C kernels/$1 add .
    git -C kernels/$1 commit -m "fix"
    git -C kernels/$1 apply "../../patches/$1.patch"
fi