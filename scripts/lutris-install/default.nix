{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "lutris-install";
  runtimeInputs =
    (with inputs.wine-overlays.packages.x86_64-linux; [
      wine-wow64-staging-10_4
      wine-wow64-staging-winetricks-10_4
    ])
    ++ (with self.packages.x86_64-linux; [
      # umu
      # wine-tkg
      # wine-ge
    ])
    ++ [
      inputs.lutris-overlay.packages.x86_64-linux.lutris
    ]
    ++ (with pkgs; [
      samba
      jansson
      gnutls
      dxvk
      vkd3d
      vkd3d-proton
      # mesa
      # driversi686Linux.mesa
    ]);
  text =
    environment
    + ''
      rm -rf "$WINEPREFIX"
      wine wineboot
      lutris -d -i ${self}/w3c.yaml
    '';
}
