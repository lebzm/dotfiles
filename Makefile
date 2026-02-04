uname := $(shell uname)
whoami := $(shell whoami)
hostname := $(shell hostname -s)

define source_brew
# Brew
eval "$$(/opt/homebrew/bin/brew shellenv)"
# End Brew
endef
export source_brew

build:
	@sudo darwin-rebuild switch --flake .#$(whoami)_$(hostname)
gc:
	@nix-collect-garbage -d

# https://brew.sh/
#
# We still require homebrew for most of GUI apps.
brew/install:
	@sudo NONINTERACTIVE=1 curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
	@echo "$$source_brew" >> ~/.zprofile

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
	@sudo nix run nix-darwin -- switch --flake .#$(whoami)_$(hostname)
nix-darwin/uninstall:
	@sudo darwin-uninstaller
