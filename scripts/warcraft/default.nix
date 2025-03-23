{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "warcraft";
  runtimeInputs =
    (with self.packages.x86_64-linux; [
      battlenet
      w3champions
      webview2
    ])
    ++ (with inputs.wine-overlays.packages.x86_64-linux; [
      wine-wow64-staging-10_4
      wine-wow64-staging-winetricks-10_4
    ]);
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

      battlenet
      w3champions
      webview2
    '';
}
