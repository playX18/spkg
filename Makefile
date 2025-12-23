# Makefile for bootstrapping and installing `spkg`.
# Requires CapyScheme to be installed and available as `capy` in PATH.

.PHONY: run update-submodules all

all: update-submodules install

install-capy:
	SCHEME=capy capy --fresh-auto-compile -L src,src/args/src -s src/main.scm -- install

update-submodules:
	git submodule update --init --recursive

test-capy:
	SCHEME=capy capy --fresh-auto-compile -L src,src/args/src -s src/main.scm -- test

install-guile:
	SCHEME=guile guile --r7rs -L src/args/src -L src -s src/main.scm -- install

test-guile:
	SCHEME=guile guile --r7rs -L src/args/src -L src -s src/main.scm -- test