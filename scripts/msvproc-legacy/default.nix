{
  self,
  inputs,
  pkgs,
  environment-legacy,
  ...
}:
pkgs.writeShellApplication {
  name = "msvproc-legacy";
  text =
    environment-legacy
    + ''
      mkdir -p "$WINEPREFIX/drive_c/windows/syswow64" "$WINEPREFIX/drive_c/windows/system32"
      cp ${self}/assets/dll/syswow64/msvproc.dll "$WINEPREFIX/drive_c/windows/syswow64"
      cp ${self}/assets/dll/system32/msvproc.dll "$WINEPREFIX/drive_c/windows/system32"
    '';
}
