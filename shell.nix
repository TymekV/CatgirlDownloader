{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Build tools
    meson
    ninja
    pkg-config
    python3
    
    # GTK4 and dependencies
    gtk4
    libadwaita
    glib
    glib-networking
    gobject-introspection
    
    # Python packages
    python3Packages.pygobject3
    python3Packages.requests
    
    # Development tools
    desktop-file-utils
    appstream-glib
    gettext
    
    # Wrapper for GTK apps
    wrapGAppsHook4
  ];
  
  shellHook = ''
    echo "CatgirlDownloader development environment"
    echo "Available commands:"
    echo "  meson setup build"
    echo "  meson compile -C build"
    echo "  meson install -C build --destdir \$PWD/install"
  '';
}