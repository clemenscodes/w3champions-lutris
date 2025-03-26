{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "w3champions";
  runtimeInputs = [
    # self.packages.x86_64-linux.wine-wow64-staging-10_4
    # self.packages.x86_64-linux.wine-wow64-staging-winetricks-10_4
    pkgs.wineWowPackages.unstableFull
    pkgs.curl
    pkgs.samba
    pkgs.jansson
    pkgs.gnutls
  ];
  text =
    environment
    + ''
      if [ ! -f "$W3C_EXE" ]; then
        echo "Installing W3Champions..."

        if [ ! -f "$W3C_SETUP_EXE" ]; then
            echo "Downloading W3Champions launcher..."
            mkdir -p "$DOWNLOADS"
            curl -L "$W3C_URL" -o "$W3C_SETUP_EXE"
        else
            echo "W3Champions launcher already downloaded."
        fi

        echo "Running W3Champions setup..."
        echo "Do not yet launch W3Champions after the installer finishes... a final step will still be needed."
        wine "$W3C_SETUP_EXE"
      fi
    '';
}
