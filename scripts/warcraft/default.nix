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
    self.packages.x86_64-linux.wine-ge
    self.packages.x86_64-linux.battlenet
    self.packages.x86_64-linux.w3champions-legacy
  ];
  text =
    environment
    + ''
      if [ ! -d "$WINEPREFIX" ]; then
        echo "Creating wine prefix..."
        mkdir -p "$WINEPREFIX"
      fi

      battlenet
      w3champions-legacy

      wine "$W3C_LEGACY_EXE"
    '';
}
