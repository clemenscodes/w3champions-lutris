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
    self.packages.x86_64-linux.wine-wow64-staging-10_4
    self.packages.x86_64-linux.wine-wow64-staging-winetricks-10_4
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
