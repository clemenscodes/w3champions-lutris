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
    ])
    ++ (with self.packages.x86_64-linux; [
      # umu
      # wine-tkg
      # wine-ge
    ])
    ++ (with pkgs; [
      curl
      dxvk
      vkd3d
      mesa
      driversi686Linux.mesa
    ]);
  text =
    environment
    + ''
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
      wine "$W3C_SETUP_EXE" || exit 1
    '';
}
