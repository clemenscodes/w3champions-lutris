{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "lutris-install";
  runtimeInputs = [
    inputs.lutris-overlay.packages.x86_64-linux.lutris
    self.packages.x86_64-linux.wine-ge
  ];
  text =
    environment
    + ''
      rm -rf "$WINEPREFIX" || true
      wine wineboot
      lutris -d -i ${self}/w3c.yaml
    '';
}
