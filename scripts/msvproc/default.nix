{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "msvproc";
  text =
    environment
    + ''
      mkdir -p "$WINEPREFIX/drive_c/windows/syswow64" "$WINEPREFIX/drive_c/windows/system32"
      cp ${self}/assets/dll/syswow64/msvproc.dll "$WINEPREFIX/drive_c/windows/syswow64"
      cp ${self}/assets/dll/system32/msvproc.dll "$WINEPREFIX/drive_c/windows/system32"
    '';
}
