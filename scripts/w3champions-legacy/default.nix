{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "w3champions-legacy";
  runtimeInputs = [
    self.packages.x86_64-linux.wine-ge
    pkgs.curl
  ];
  text =
    environment
    + ''
      if [ ! -f "$W3C_LEGACY_EXE" ]; then
        echo "Installing W3Champions legacy..."

        if [ ! -f "$W3C_LEGACY_SETUP_EXE" ]; then
            echo "Downloading legacy W3Champions launcher..."
            mkdir -p "$DOWNLOADS"
            curl -L "$W3C_LEGACY_URL" -o "$W3C_LEGACY_SETUP_EXE"
        else
            echo "W3Champions legacy launcher already downloaded."
        fi

        echo "Running W3Champions legacy setup..."
        wine "$W3C_LEGACY_SETUP_EXE" || exit 1
      fi
    '';
}
