{
  self,
  inputs,
  pkgs,
  environment-legacy,
  ...
}:
pkgs.writeShellApplication {
  name = "warcraft-legacy";
  runtimeInputs = [
    self.packages.x86_64-linux.wine-ge
    self.packages.x86_64-linux.battlenet-legacy
    self.packages.x86_64-linux.w3champions-legacy
  ];
  text =
    environment-legacy
    + ''
      if [ ! -d "$WINEPREFIX" ]; then
        echo "Creating wine prefix..."
        mkdir -p "$WINEPREFIX"
      fi

      battlenet-legacy
      w3champions-legacy

      WARCRAFT_PATH="''${WARCRAFT_PATH:-}"

      if [ -n "$WARCRAFT_PATH" ]; then
        echo "Copying $WARCRAFT_PATH to $WARCRAFT_HOME"
        cp -r "$WARCRAFT_PATH" "$WARCRAFT_HOME"
      fi

      echo
      echo "After starting Battle.net via W3Champions, it is necessary to restart Bonjour."
      echo
      echo "wine net stop 'Bonjour Service'"
      echo "wine net start 'Bonjour Service'"
      echo
      wine "$W3C_LEGACY_EXE"
      wineserver -k
    '';
}
