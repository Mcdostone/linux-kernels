.PHONY: all clean test
.PRECIOUS: archives/linux-%.tar.xz kernels/tmp/%

all: versions.json
	touch stderr.log
	@git -C linux restore --staged .
	@git -C linux restore .
	@git -C linux clean -fdq
	@jq -r '.[]' versions.json | xargs -I{} -P1 make -s output/{}.json

clean:
	rm -rf output kernels stderr.log

kernels/archives/linux-%.tar.xz:
	mkdir -p $(shell dirname $@)
	link=$$(jq -r ".[\"$*\"].link" kernels.json); \
	wget -q --no-clobber "$$link" -O $@

prepare-legacy-%: kernels/archives/linux-%.tar.xz 
	mkdir -p kernels/tmp/$*
	tar -xJf $^ --strip-components 1 -C kernels/tmp/$*
	ln -fs $$PWD/kernels/tmp/$* kernels/current
	@bash fix.sh $*
	make -s parse-$*
	rm -rf kernels/tmp/$*

prepare-modern-%: linux
	git -C linux restore .
	git -C linux checkout v$*
	ln -fs $^ kernels/current
	@bash fix.sh $*
	make -s parse-$*

parse-%: 
	/usr/bin/time -f "[$*] Parsing: %es" ./pouet kernels/current > kernels/.tmp 2>> stderr.log

output/%.json:
	@mkdir -p $(dir $@)
	rm -rf kernels/current
	t=$$(jq -r ".[\"$*\"] | if has(\"legacy\") then \"legacy\" else \"modern\" end" kernels.json); \
	make prepare-$$t-$*
	mv kernels/.tmp $@

linux:
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git $@
	git -C $@ fetch --all --tags

test: versions.json
	@jq -r '.[]' versions.json | xargs -I{} -P1 make -s output/{}.json delete-{}

delete-%:
	@echo "[]" > output/$*.json

versions.json:
	jq -r ". | keys[]" kernels.json  | sort -V | jq -Rs 'split("\n")' > $@
