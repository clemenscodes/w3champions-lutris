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
    self.packages.x86_64-linux.wine-ge
    pkgs.curl
  ];
  text =
    environment
    + ''
      echo "WARNING: This is currently broken with wine-ge."
      echo "Downloading WebView2 runtime installer..."

      if [ ! -f "$WEBVIEW2_SETUP_EXE" ]; then
        mkdir -p "$DOWNLOADS"
        curl -L "$WEBVIEW2_URL" -o "$WEBVIEW2_SETUP_EXE"
      fi

      echo "Installing the WebView2 runtime..."
      ${self.packages.x86_64-linux.wine-wow64-staging-10_4}/bin/wine "$WEBVIEW2_SETUP_EXE" || exit 1

      echo "Setting 'msedgewebview2.exe' to Windows 7"
      wine "$WINEPREFIX/drive_c/windows/regedit.exe" /S "${self}/registry/msedgewebview2.exe.reg"

      echo "Successfully installed WebView2 runtime"

      echo "Now, to finish off, installing vcrun2017, ole32 and mf is needed using winetricks"
      echo "For some reason, this will hang endlessly when ran in a script, but it will work when running manually in a terminal"
      echo "Run the following command in the terminal"
      echo "winetricks -q --force vcrun2017 ole32 mf"
      echo "Any errors during this installation regarding winemenubuilder can be ignored."
      echo "Additionally, it may be required to set Battle.net.exe and BlizzardBrowser.exe to Windows 7"
    '';
}
