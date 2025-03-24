{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "battlenet";
  runtimeInputs =
    (with inputs.wine-overlays.packages.x86_64-linux; [
      # wine-wow64-staging-10_4
    ])
    ++ (with self.packages.x86_64-linux; [
      # umu
      # wine-tkg
      # wine-ge
    ])
    ++ (with pkgs; [
      winetricks
      curl
      samba
      jansson
      gnutls
      zenity
      mesa
      driversi686Linux.mesa
    ]);
  text =
    environment
    + ''
      echo "Installing Battle.net..."

      if [ ! -f "$BNET_SETUP_EXE" ]; then
        echo "Downloading Battle.net launcher..."
        mkdir -p "$DOWNLOADS"
        curl -L "$BATTLENET_URL" -o "$BNET_SETUP_EXE"
      else
        echo "Battle.net launcher already downloaded."
      fi

      # echo "Writing a Battle.net config file"
      # mkdir -p "$BNET_CONFIG_HOME"
      # cat ${self}/assets/Battle.net.config.json > "$BNET_CONFIG"

      echo "Running Battle.net setup..."
      wine "$BNET_SETUP_EXE"

      if [[ ! -f "$BNET_EXE" ]]; then
        echo "Failed to install Battle.net"
        exit 1
      fi

      echo "Successfully installed Battle.net"
    '';
}
