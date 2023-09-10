.PHONY: all clean test pull

all:
	./pouet list > .kernels.json
	touch stderr.log
	@jq -r '. | keys[]' .kernels.json | xargs -I{} -P1 make -s output/{}.json

pull: linux
	@git -C linux restore .
	@git -C linux clean -fd
	@git -C linux fetch origin master:master

clean:
	rm -rf output/* kernels stderr.log

output/%.json:
	@mkdir -p $(shell dirname $@)
	./pouet prepare $*
	@bash fix.sh $*
	./pouet wait
	./pouet extract --kernel-version $* --kernel-directory kernels/current kernels/current > kernels/.tmp 2>> stderr.log
	@mv kernels/.tmp $@
	@rm -rf "kernels/tmp"

kernels/repository:
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git $@
	git -C $@ fetch --all --tags

kernels/repository:
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git $@
	git -C $@ fetch --all --tags