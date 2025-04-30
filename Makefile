NIXARGS=-I nixpkgs=$(NIXPKGS)

NIXPKGS=channel:nixos-24.11

all:
	#-- Nothing to be done by default.

fmt:
	nix-shell $(NIXARGS) '<nixpkgs/nixos>' -p alejandra --run 'alejandra .'

repl:
	nix repl $(NIXARGS) --file '<nixpkgs/nixos>' -I nixos-config=./configuration.nix

.PHONY: fmt build
