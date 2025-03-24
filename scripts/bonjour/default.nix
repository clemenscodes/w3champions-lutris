{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "bonjour";
  runtimeInputs =
    (with inputs.wine-overlays.packages.x86_64-linux; [
      # wine-wow64-staging-10_4
    ])
    ++ (with self.packages.x86_64-linux; [
      umu
      # wine-tkg
      # wine-ge
    ])
    ++ (with pkgs; [
      curl
      samba
      jansson
      gnutls
      dxvk
      vkd3d
      vkd3d.lib
      vkd3d-proton
      mesa
      driversi686Linux.mesa
    ]);
  text =
    environment
    + ''
      echo "Installing Bonjour..."

      if [ ! -f "$BONJOUR_MSI" ]; then
        echo "Downloading Bonjour installer..."
        mkdir -p "$DOWNLOADS"
        curl -L "$BONJOUR_URL" -o "$BONJOUR_MSI"
      else
        echo "Bonjour installer already downloaded."
      fi

      umu-run "$BONJOUR_MSI"

      if [ ! -f "$BONJOUR_EXE" ]; then
        echo "Failed installing Bonjour"
        exit 1
      fi

      echo "Running Bonjour..."

      umu-run "$WINEPREFIX/drive_c/windows/net.exe" stop 'Bonjour Service'
      umu-run "$WINEPREFIX/drive_c/windows/net.exe" start 'Bonjour Service'
    '';
}
