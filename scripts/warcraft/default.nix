{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "warcraft";
  runtimeInputs = [
    self.packages.x86_64-linux.wine-wow64-staging-10_4
    self.packages.x86_64-linux.wine-wow64-staging-winetricks-10_4
    self.packages.x86_64-linux.battlenet
    self.packages.x86_64-linux.w3champions
    self.packages.x86_64-linux.webview2
    pkgs.samba
    pkgs.jansson
    pkgs.gnutls
  ];
  text =
    environment
    + ''
      if [ ! -d "$WINEPREFIX" ]; then
        echo "Creating wine prefix..."
        mkdir -p "$WINEPREFIX"
      fi

      battlenet
      w3champions
      webview2

      WARCRAFT_PATH="''${WARCRAFT_PATH:-}"

      if [ -n "$WARCRAFT_PATH" ]; then
        echo "Copying $WARCRAFT_PATH to $WARCRAFT_HOME"
        cp -r "$WARCRAFT_PATH" "$WARCRAFT_HOME"
        rm -rf "$WARCRAFT_HOME/_retail_/webui" || true
        mkdir -p "$WARCRAFT_HOME/_retail_/webui"
        cp ${self}/assets/index.html "$WARCRAFT_HOME/_retail_/webui/index.html"
      fi

      wine "$W3C_EXE"
    '';
}
