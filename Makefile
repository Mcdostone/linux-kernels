.PHONY: all clean test pull

all: pull
	./pouet all --patches-directory ./patches


clean:
	rm -rf output/* kernels/tmp kernels/current stderr.log

output/%.json:
	@mkdir -p $(shell dirname $@)
	./pouet prepare $*
	./pouet extract --kernel-version $* --kernel-directory kernels/current kernels/current
	@mv kernels/.tmp $@
	@rm -rf "kernels/tmp"

kernels/repository:
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git $@
	git -C $@ fetch --all --tags

pull: kernels/repository
	@git -C $^ restore .
	@git -C $^ clean -fd
	-@git -C $^ fetch origin
