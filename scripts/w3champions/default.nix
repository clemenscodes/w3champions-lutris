{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "w3champions";
  runtimeInputs =
    (with inputs.wine-overlays.packages.x86_64-linux; [
      wine-wow64-staging-10_4
      wine-wow64-staging-winetricks-10_4
    ])
    ++ (with pkgs; [curl]);
  text =
    environment
    + ''
      rm -rf "$WINEPREFIX"

      if [ ! -d "$WINEPREFIX" ]; then
        echo "Initializing Wine prefix..."
        mkdir -p "$WINEPREFIX"
      else
        echo "Wine prefix already exists, skipping initialization."
      fi

      echo "Setting Windows 7 mode for wine"
      wine "$WINEPREFIX/drive_c/windows/regedit.exe" /S "${self}/registry/wine.reg"

      echo "Enabling DXVA2 for wine"
      wine "$WINEPREFIX/drive_c/windows/regedit.exe" /S "${self}/registry/dxva2.reg"

      mkdir -p "$DOWNLOADS"

      echo "Installing W3Champions..."

      if [ ! -f "$W3C_SETUP_EXE" ]; then
          echo "Downloading W3Champions launcher..."
          curl -L "$W3C_URL" -o "$W3C_SETUP_EXE"
      else
          echo "W3Champions launcher already downloaded."
      fi

      echo "Running W3Champions setup..."
      echo "Do not yet launch W3Champions after the installer finishes... a final step will still be needed."
      wine "$W3C_SETUP_EXE" || exit 1
    '';
}
