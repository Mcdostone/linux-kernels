#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# File name          : get_kernels.py
# Author             : Podalirius (@podalirius_)
# Date created       : 3 Mar 2022

# https://cdn.kernel.org/pub/linux/kernel/

import sys
import json
import os
import re
import requests
from bs4 import BeautifulSoup

## List versions
r = requests.get('https://cdn.kernel.org/pub/linux/kernel/')
versions = [a['href'] for a in BeautifulSoup(r.content.decode('UTF-8'), 'lxml').findAll('a') if a['href'].startswith('v')]

listofkernels = {}
for version in versions:
    print('[+] Parsing %s ...' % version, file=sys.stderr)
    r = requests.get('https://cdn.kernel.org/pub/linux/kernel/%s/' % version)
    soup = BeautifulSoup(r.content.decode('UTF-8'), 'lxml')

    
    for a in soup.findAll('a'):
        v = a['href'].replace('.tar.xz', '').replace('linux-', '')
        if a['href'].startswith('linux') and a['href'].endswith('xz') and 'patch' not in a['href']:
            listofkernels[v] = {
            'version': v,
                'link': 'https://cdn.kernel.org/pub/linux/kernel/%s%s' % (version, a['href']),
                'commands': [],
            }


print(json.dumps(listofkernels, indent=4))
