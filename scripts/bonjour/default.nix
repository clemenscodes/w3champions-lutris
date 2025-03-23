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
      wine-wow64-staging-10_4
      wine-wow64-staging-winetricks-10_4
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
      echo "Installing Bonjour..."

      if [ ! -f "$BONJOUR_MSI" ]; then
        echo "Downloading Bonjour installer..."
        mkdir -p "$DOWNLOADS"
        curl -L "$BONJOUR_URL" -o "$BONJOUR_MSI"
      else
        echo "Bonjour installer already downloaded."
      fi

      wine "$BONJOUR_MSI"

      if [ ! -f "$BONJOUR_EXE" ]; then
        echo "Failed installing Bonjour"
        exit 1
      fi

      echo "Running Bonjour..."

      wine net stop 'Bonjour Service'
      wine net start 'Bonjour Service'
    '';
}
