{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, gtk4
, libadwaita
, glib
, glib-networking
, gobject-introspection
, wrapGAppsHook4
, desktop-file-utils
, appstream-glib
, gettext
}:

python3.pkgs.buildPythonApplication rec {
  pname = "catgirldownloader";
  version = "0.3.0";
  format = "other";

  src = ./.;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    appstream-glib
    gettext
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
    glib-networking
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    requests
  ];

  dontWrapGApps = true;

  # Ensure proper GSettings schema compilation and desktop file validation
  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas/
    
    # Validate desktop file if desktop-file-utils is available
    if command -v desktop-file-validate >/dev/null 2>&1; then
      desktop-file-validate $out/share/applications/*.desktop
    fi
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # Ensure the application can find its resources
  postFixup = ''
    wrapProgram $out/bin/catgirldownloader \
      --prefix PATH : ${lib.makeBinPath [ glib ]} \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"
  '';

  meta = with lib; {
    description = "A GTK4 application that downloads images of catgirl based on nekos.moe";
    longDescription = ''
      CatgirlDownloader is a GTK4 application that provides a simple interface
      for downloading catgirl images from the nekos.moe API. It features a modern
      libadwaita interface with support for NSFW filtering preferences.
    '';
    homepage = "https://github.com/TymekV/CatgirlDownloader";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ]; # Add maintainer here when upstreaming
    platforms = platforms.linux;
    mainProgram = "catgirldownloader";
  };
}