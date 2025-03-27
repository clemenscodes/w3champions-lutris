{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "lutris-w3c";
  runtimeInputs = [inputs.lutris-overlay.packages.x86_64-linux.lutris];
  text =
    environment
    + ''
      rm -rf "$WINEPREFIX" || true

      WARCRAFT_PATH="''${WARCRAFT_PATH:-}"

      if [ -n "$WARCRAFT_PATH" ]; then
        echo "Copying $WARCRAFT_PATH to $WARCRAFT_HOME"
        mkdir -p "$PROGRAM_FILES86"
        cp -r "$WARCRAFT_PATH" "$WARCRAFT_HOME"
        rm -rf "$WARCRAFT_HOME/_retail_/webui" || true
        mkdir -p "$WARCRAFT_HOME/_retail_/webui"
        cp ${self}/assets/index.html "$WARCRAFT_HOME/_retail_/webui/index.html"
      fi

      mkdir -p "$WINEPREFIX/drive_c/windows/syswow64" "$WINEPREFIX/drive_c/windows/system32"
      cp ${self}/assets/dll/syswow64/msvproc.dll "$WINEPREFIX/drive_c/windows/syswow64"
      cp ${self}/assets/dll/system32/msvproc.dll "$WINEPREFIX/drive_c/windows/system32"

      lutris -d -i ${self}/w3c.yaml
    '';
}
