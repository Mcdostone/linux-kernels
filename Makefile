.PHONY: all clean test pull

all: #pull
	./pouet --verbose all --no-cache --patches-directory ./patches/

clean:
	rm -rf output/* kernels/tmp kernels/current stderr.log

kernels/repository:
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git $@
	git -C $@ fetch --all --tags

pull: kernels/repository
	@git -C $^ restore .
	@git -C $^ clean -fd
	-@git -C $^ fetch origin
