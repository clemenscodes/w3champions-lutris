{
  self,
  inputs,
  pkgs,
  environment-legacy,
  ...
}:
pkgs.writeShellApplication {
  name = "battlenet-legacy";
  runtimeInputs = [
    self.packages.x86_64-linux.wine-ge
    pkgs.winetricks
    pkgs.curl
    # pkgs.samba
    # pkgs.jansson
    # pkgs.gnutls
  ];
  text =
    environment-legacy
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

        echo "Running Battle.net setup..."
        wine "$BNET_SETUP_EXE"
        echo "Successfully installed Battle.net"
        wineserver -k
      fi

      if [[ ! -f "$BNET_EXE" ]]; then
        echo "Failed to install Battle.net"
        exit 1
      fi
    '';
}
