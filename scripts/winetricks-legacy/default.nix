{
  self,
  inputs,
  pkgs,
  environment-legacy,
  ...
}:
pkgs.writeShellApplication {
  name = "wtl";
  runtimeInputs = [
    self.packages.x86_64-linux.wine-ge
    pkgs.winetricks
    pkgs.samba
    pkgs.jansson
    pkgs.gnutls
  ];
  text =
    environment-legacy
    + ''
      winetricks -q --gui
    '';
}
