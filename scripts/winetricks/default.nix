{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "wt";
  runtimeInputs = [
    self.packages.x86_64-linux.wine-wow64-staging-10_4
    self.packages.x86_64-linux.wine-wow64-staging-winetricks-10_4
    # pkgs.wineWowPackages.unstableFull
    pkgs.winetricks
    pkgs.samba
    pkgs.jansson
    pkgs.gnutls
  ];
  text =
    environment
    + ''
      winetricks -q --gui
    '';
}
