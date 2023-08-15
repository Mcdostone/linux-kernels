.PHONY: all clean test pull

all: versions.json pull
	touch stderr.log
	@git -C linux fetch origin master:master
	@git -C linux restore --staged .
	@git -C linux restore .
	@git -C linux clean -fd
	@jq -r '.[]' versions.json | xargs -I{} -P1 make -s output/{}.json

fix: 
	@jq -r '.[]' versions.json | xargs -I{} -P1 make -s patches/{}.patch

pull: linux
	@git -C linux restore .
	@git -C linux clean -fd
	@git -C linux fetch origin master:master

clean:
	rm -rf output/* kernels stderr.log

kernels/archives/linux-%.tar.xz: releases.json
	mkdir -p $(shell dirname $@)
	link=$$(jq -r ".[\"$*\"].link" releases.json); \
	wget  --no-clobber "$$link" -O $@

prepare-legacy-%: kernels/archives/linux-%.tar.xz
	mkdir -p kernels/tmp/$*
	tar -xJf $^ --strip-components 1 -C kernels/tmp/$*
	ln -fs $$PWD/kernels/tmp/$* kernels/current
	@bash fix.sh $*

prepare-modern-%: linux
	git -C linux restore --staged .
	git -C linux restore .
	git -C linux clean -fd
	git -C linux checkout v$*
	ln -fs $$PWD/linux kernels/current
	git -C linux clean -fd
	@bash fix.sh $*

parse-%: 
	echo "Parsing $*"
	t=$$(jq -r ". | if index(\"$*\") then \"config-in-to-kconfig\" else \"kconfig\" end" legacy.json); \
	/usr/bin/time -f "[$*] Parsing: %es" ./pouet extract-$$t $$OPTIONS --kernel-directory kernels/current kernels/current > kernels/.tmp 2>> stderr.log

output/%.json:
	mkdir -p kernels
	@mkdir -p $(dir $@)
	rm -f kernels/current
	if git -C linux tag | grep "v$*\$$" > /dev/null; then make prepare-modern-$*; else make prepare-legacy-$*; fi
	make -s parse-$*
	#mv kernels/.tmp $@
	rm -rf "kernels/tmp/$*"

linux:
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git $@
	git -C $@ fetch --all --tags

test: versions.json
	@jq -r '.[]' versions.json | xargs -I{} -P1 make -s output/{}.json delete-{}

delete-%:
	@echo "[]" > output/$*.json

releases.json:
	./pouet list > $@

versions.json: releases.json
	jq -r ". | keys[]" releases.json  | sort -V | jq -Rs 'split("\n")' > $@
