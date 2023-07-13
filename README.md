# Linux-kernels

```bash
docker build -t test .
docker run --rm -it test > kernels.json
mkdir -p archives
jq  '.[].link' kernels.json | xargs -I {} -P8 curl --no-clobber {} -O --output-dir archives
jq  '.[].link' kernels.json | xargs -I {} -P8 wget --no-clobber {} -P archives

cat kernels.json | jq  '.[].link' | uniq | sed -r 's#https://cdn.kernel.org/pub/linux/kernel/v[0-9]../linux-##g' | sed 's/.tar.xz//g' | jq --slurp '.' | jq  '.[] | [{ "key": ., "value": ""}] | from_entries' | jq -s add
```

- /home/yannp/Documents/linux-kernels/kernels/3.0.2/arch/arm/plat-tcc/Kconfig
- /home/yannp/Documents/linux-kernels/kernels/3.0.18/arch/arm/plat-tcc/Kconfig
- /home/yannp/Documents/linux-kernels/kernels/3.0.19/arch/arm/plat-tcc/Kconfig
- /home/yannp/Documents/linux-kernels/kernels/3.0.20/arch/arm/plat-tcc/Kconfig
- /home/yannp/Documents/linux-kernels/kernels/3.0.21/arch/arm/plat-tcc/Kconfig
- /home/yannp/Documents/linux-kernels/kernels/3.0.22/arch/arm/plat-tcc/Kconfig
- /home/yannp/Documents/linux-kernels/kernels/3.0.23/arch/arm/plat-tcc/Kconfig
- /home/yannp/Documents/linux-kernels/kernels/3.0.2/arch/arm/plat-tcc/Kconfig
- /home/yannp/Documents/linux-kernels/kernels/3.12.29/arch/arm/mach-at91/Kconfig
- /home/yannp/Documents/linux-kernels/kernels/3.12.30/arch/arm/mach-at91/Kconfig
- /home/yannp/Documents/linux-kernels/kernels/3.12.31/arch/arm/mach-at91/Kconfig
- /home/yannp/Documents/linux-kernels/kernels/3.12.32/arch/arm/mach-at91/Kconfig
- /home/yannp/Documents/linux-kernels/kernels/3.12.3/arch/arm/mach-at91/Kconfig
- /home/yannp/Documents/linux-kernels/kernels/3.2.99/arch/arm/plat-tcc/Kconfig
- /home/yannp/Documents/linux-kernels/kernels/3.2/arch/arm/plat-tcc/Kconfig