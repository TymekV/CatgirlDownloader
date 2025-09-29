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

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "A GTK4 application that downloads images of catgirl based on nekos.moe";
    homepage = "https://github.com/TymekV/CatgirlDownloader";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}