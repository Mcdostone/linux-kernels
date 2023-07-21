# Linux-kernels
[![General badge](https://img.shields.io/badge/kernel.org-archives-black.svg?logo=linux)](https://cdn.kernel.org/pub/linux/kernel/)



```bash
docker build -t test .
docker run --rm -it test > kernels.json
mkdir -p archives
jq  '.[].link' kernels.json | xargs -I {} -P8 curl --no-clobber {} -O --output-dir archives
jq  '.[].link' kernels.json | xargs -I {} -P8 wget --no-clobber {} -P archives

cat kernels.json | jq  '.[].link' | uniq | sed -r 's#https://cdn.kernel.org/pub/linux/kernel/v[0-9]../linux-##g' | sed 's/.tar.xz//g' | jq --slurp '.' | jq  '.[] | [{ "key": ., "value": ""}] | from_entries' | jq -s add
```
