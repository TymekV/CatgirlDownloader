{
  description = "A GTK4 application that downloads images of catgirl based on nekos.moe";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        catgirldownloader = pkgs.callPackage ./default.nix { };
      in
      {
        packages = {
          default = catgirldownloader;
          catgirldownloader = catgirldownloader;
        };

        checks = {
          # Simple build test
          build-test = catgirldownloader;
          
          # Test that the binary exists and is executable
          binary-test = pkgs.runCommand "catgirldownloader-binary-test" {} ''
            ${catgirldownloader}/bin/catgirldownloader --help > /dev/null 2>&1 || true
            test -x ${catgirldownloader}/bin/catgirldownloader
            touch $out
          '';
        };

        apps.default = {
          type = "app";
          program = "${catgirldownloader}/bin/catgirldownloader";
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ catgirldownloader ];
          buildInputs = with pkgs; [
            # Development tools
            python3
            meson
            ninja
            pkg-config
            
            # Runtime dependencies for development
            gtk4
            libadwaita
            glib
            glib-networking
            gobject-introspection
          ];
        };
      }) // {
      # NixOS module
      nixosModules.default = { config, lib, pkgs, ... }:
        with lib;
        let
          cfg = config.programs.catgirldownloader;
        in
        {
          options.programs.catgirldownloader = {
            enable = mkEnableOption "Catgirl Downloader";
          };

          config = mkIf cfg.enable {
            environment.systemPackages = [
              (pkgs.callPackage ./default.nix { })
            ];
          };
        };
    };
}