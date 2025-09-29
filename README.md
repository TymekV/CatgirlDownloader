# CatgirlDownloader
A GTK4 application that downloads images of catgirl based on https://nekos.moe
![](http://nyarchlinux.moe/assets/img/catgirldownloader-screenshots.png)

## Building
1. `meson setup <build_dir> [--prefix <prefix>]`
> Prefix is `/usr/local` by default
2. `meson compile -C <build_dir>`
3. `meson install -C <build_dir> [--destdir <dest_dir>]`
> Package is installed globally by default, or in `<dest_dir>` if `--destdir` is specified (path are relative to `<build_dir>` )

## Packaging

### Traditional Packaging
Make sure you have `nfpm` and `sh` installed, then run `./package.sh`.

### NixOS/Nix Packaging
This repository includes Nix packaging files for easy installation on NixOS and other Nix-based systems.

See [NIX_PACKAGING.md](NIX_PACKAGING.md) for detailed instructions.

Quick start:
```bash
# Run directly with flakes
nix run github:TymekV/CatgirlDownloader

# Or build locally
nix build
./result/bin/catgirldownloader
```