.PHONY: all clean test

all:
	@jq -r '.[]' versions.json | xargs -I{} -P1 time -f "{} done in %es" make -s output/{}.json

clean:
	rm -rf output stderr.log

output/%.json: linux
	@mkdir -p output
	@git -C linux restore .
	git -C linux checkout v$*
	@bash fix.sh $*
	./pouet --kernel-directory linux linux > $@ 2>> stderr.log

linux:
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git $@
	git -C $@ fetch --all --tags

test:
	@jq -r '.[]' versions.json | xargs -I{} -P1 time -f "{} done in %es" make -s output/{}.json delete-{}

delete-%:
	@echo "[]" > output/$*.json

versions.json:
	jq -r ". | keys[]" kernels.json  | sort -V | jq -Rs 'split("\n")' > $@
