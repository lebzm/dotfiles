# dotfiles

> TODO:
>
> - Turn this README into a golden path.
> - Consider using `config.lib.file.mkOutOfStoreSymlink` for faster ricing.

## Bootstrap

Make sure your hostname `hostname -s` is registered in the
`darwinConfigurations` and username `whoami` is registered in the
`homeConfigurations` flake outputs [flake.nix](flake.nix).

Run bootstrap script

```sh
curl -fsSL https://raw.githubusercontent.com/lebzm/dotfiles/main/bootstrap.sh | sh
```

or clone the repo first into `~/.config/dotfiles` then run the script

```sh
./bootstrap.sh
```
