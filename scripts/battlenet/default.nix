{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "battlenet";
  runtimeInputs = [
    self.packages.x86_64-linux.wine-ge
    pkgs.winetricks
    pkgs.curl
    pkgs.samba
    pkgs.jansson
    pkgs.gnutls
  ];
  text =
    environment
    + ''
      if [ ! -f "$BNET_EXE" ]; then
        echo "Installing Battle.net..."

        if [ ! -f "$BNET_SETUP_EXE" ]; then
          echo "Downloading Battle.net launcher..."
          mkdir -p "$DOWNLOADS"
          curl -L "$BATTLENET_URL" -o "$BNET_SETUP_EXE"
        else
          echo "Battle.net launcher already downloaded."
        fi

        winetricks -q --force arial tahoma dxvk

        cp ${self}/assets/dll/syswow64/msvproc.dll "$WINEPREFIX/drive_c/windows/syswow64"
        cp ${self}/assets/dll/system32/msvproc.dll "$WINEPREFIX/drive_c/windows/system32"

        echo "Setting Windows 7 mode for wine"
        wine "$WINEPREFIX/drive_c/windows/regedit.exe" /S "${self}/registry/wine.reg"

        echo "Enabling DXVA2 for wine"
        wine "$WINEPREFIX/drive_c/windows/regedit.exe" /S "${self}/registry/dxva2.reg"

        echo "Writing a Battle.net config file"
        mkdir -p "$BNET_CONFIG_HOME"
        cat ${self}/assets/Battle.net.config.json > "$BNET_CONFIG"

        echo "Running Battle.net setup..."
        wine "$BNET_SETUP_EXE"
        echo "Successfully installed Battle.net"
      fi

      if [[ ! -f "$BNET_EXE" ]]; then
        echo "Failed to install Battle.net"
        exit 1
      fi
    '';
}
