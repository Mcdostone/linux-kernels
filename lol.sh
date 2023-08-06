#!/usr/bin/env bash

ROOT="$(dirname $(realpath $0))"


sed 's###'  $ROOT/$1/arch/arm/Config.in