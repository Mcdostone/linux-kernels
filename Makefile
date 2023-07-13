.PHONY: run
.PRECIOUS: archives/linux-%.tar.xz
all:
	jq -r '. | keys[]' kernels.json | xargs -I{} -P1 make output/{}.json

clean:
	rm -rf kernels output stderr.log

output/%.json: kernels/%
	mkdir -p output
	./pouet --kernel-directory $^ $^ > $@ 2>> stderr.log
	#rm -rf $^ archives/linux-$*.tar.xz

kernels/%: archives/linux-%.tar.xz
	mkdir -p $@
	tar -xJf $^  --strip-components 1 -C $@
	bash fix.sh $*

archives/linux-%.tar.xz:
	mkdir -p $(shell dirname $@)
	link=$$(jq -r ".[\"$*\"].link" kernels.json); \
	wget --no-clobber "$$link" -O $@

test:
	jq -r '. | keys[]' kernels.json | xargs -I{} -P1 make output/{}.json delete-{}

delete-%:
	rm -rf kernels/%
	echo "[]" > output/$*.json