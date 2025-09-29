# NixOS Packaging for CatgirlDownloader

This repository now includes Nix packaging files for easy installation on NixOS and other Nix-based systems.

## Files Added

- `default.nix` - Main Nix derivation for the package
- `flake.nix` - Modern Nix flake configuration
- `shell.nix` - Development shell environment
- `NIX_PACKAGING.md` - This documentation

## Installation Methods

### Method 1: Using Nix Flakes (Recommended)

```bash
# Run directly
nix run github:TymekV/CatgirlDownloader

# Install to your profile
nix profile install github:TymekV/CatgirlDownloader

# Build locally
nix build
./result/bin/catgirldownloader
```

### Method 2: Using traditional Nix

```bash
# Build the package
nix-build

# Install to your profile
nix-env -f default.nix -i
```

### Method 3: NixOS System Configuration

Add to your `configuration.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    catgirldownloader.url = "github:TymekV/CatgirlDownloader";
  };

  outputs = { self, nixpkgs, catgirldownloader }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        {
          environment.systemPackages = [
            catgirldownloader.packages.x86_64-linux.default
          ];
        }
      ];
    };
  };
}
```

Or using the provided NixOS module:

```nix
{
  imports = [ catgirldownloader.nixosModules.default ];
  programs.catgirldownloader.enable = true;
}
```

## Development

### Enter Development Shell

```bash
# Using flakes
nix develop

# Using shell.nix
nix-shell

# Or with direnv for automatic shell switching
echo "use flake" > .envrc
direnv allow
```

### Build from Source

```bash
# Enter development environment
nix develop

# Build using meson
meson setup build
meson compile -C build
meson install -C build --destdir $PWD/install
```

## Dependencies

The Nix package automatically handles all dependencies:

- **Build dependencies**: meson, ninja, pkg-config, gobject-introspection
- **Runtime dependencies**: GTK4, libadwaita, glib, glib-networking
- **Python dependencies**: pygobject3, python3-requests

## Package Information

- **Name**: catgirldownloader
- **Version**: 0.3.0
- **License**: GPL-3.0-or-later
- **Platforms**: Linux
- **Desktop Integration**: Includes .desktop file, icons, and AppStream metadata

## Troubleshooting

### Missing Desktop Integration

If the application doesn't appear in your desktop environment's application menu, you may need to rebuild your desktop database:

```bash
update-desktop-database ~/.local/share/applications
```

### Runtime Issues

Ensure you have the required system services running:
- D-Bus
- A desktop environment or window manager that supports GTK4

For more help, please open an issue on the GitHub repository.