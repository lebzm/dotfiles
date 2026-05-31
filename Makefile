hostname := $(shell hostname -s)
whoami := $(shell whoami)

system:
	@sudo darwin-rebuild switch --flake .#$(hostname)
home:
	@home-manager switch --flake .#$(whoami)
build: system home
gc:
	@nix-collect-garbage -d

# https://lix.systems
#
# Lix is a modern implementation of Nix package manager.
nix/install:
	@curl -sSf -L https://install.lix.systems/lix | sh -s -- install --no-confirm
nix/uninstall:
	@/nix/lix-installer uninstall
nix/upgrade:
	@sudo -i nix upgrade-nix

# https://github.com/nix-darwin/nix-darwin
#
# A declarative system approach for macOS.
nix-darwin/install:
	@sudo nix run nix-darwin -- switch --flake .#$(hostname)
nix-darwin/uninstall:
	@sudo darwin-uninstaller
