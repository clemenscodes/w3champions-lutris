{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "webview2";
  runtimeInputs = [
    # self.packages.x86_64-linux.wine-wow64-staging-10_4
    # self.packages.x86_64-linux.wine-wow64-staging-winetricks-10_4
    pkgs.wineWowPackages.stagingFull
    pkgs.wineWow64Packages.stagingFull
    # pkgs.winePackages.stagingFull
    # pkgs.wine64Packages.stagingFull
    pkgs.curl
    # pkgs.samba
    # pkgs.jansson
    # pkgs.gnutls
  ];
  text =
    environment
    + ''
      if [ ! -d "$PROGRAM_FILES86/Microsoft/EdgeWebView/Application" ]; then
        if [ ! -f "$WEBVIEW2_SETUP_EXE" ]; then
          echo "Downloading WebView2 runtime installer..."
          mkdir -p "$DOWNLOADS"
          curl -L "$WEBVIEW2_URL" -o "$WEBVIEW2_SETUP_EXE"
        fi

        echo "Installing the WebView2 runtime..."
        wine "$WEBVIEW2_SETUP_EXE" || exit 1

        wineserver -k

        echo "Setting 'msedgewebview2.exe' to Windows 7"
        wine "$WINEPREFIX/drive_c/windows/regedit.exe" /S "${self}/registry/msedgewebview2.exe.reg"

        echo "Successfully installed WebView2 runtime"

        wineserver -k
      fi
    '';
}
