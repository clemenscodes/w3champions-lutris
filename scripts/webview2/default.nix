{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "webview2";
  runtimeInputs =
    (with inputs.wine-overlays.packages.x86_64-linux; [
      # wine-wow64-staging-10_4
    ])
    ++ (with self.packages.x86_64-linux; [
      battlenet
      w3champions
      umu
      # wine-ge
    ])
    ++ (with pkgs; [
      winetricks
      curl
      samba
      jansson
      gnutls
      dxvk
      vkd3d
      vkd3d.lib
      vkd3d-proton
      mesa
      driversi686Linux.mesa
    ]);
  text =
    environment
    + ''
      echo "Downloading WebView2 runtime installer..."
      mkdir -p "$DOWNLOADS"
      curl -L "$WEBVIEW2_URL" -o "$WEBVIEW2_SETUP_EXE"

      echo "Installing the WebView2 runtime..."
      umu-run "$WEBVIEW2_SETUP_EXE" || exit 1

      echo "Setting 'msedgewebview2.exe' to Windows 7"
      umu-run "$WINEPREFIX/drive_c/windows/regedit.exe" /S "${self}/registry/msedgewebview2.exe.reg"

      # echo "Installing d3dcompiler_47 for WebView2..."
      # umu-run winetricks -q --force d3dcompiler_47 || true
      #
      # echo "Installing d3drm for WebView2..."
      # umu-run winetricks -q --force d3drm || true
      #
      # echo "Installing d3dx11_42 for WebView2..."
      # umu-run winetricks -q --force d3dx11_42 || true
      
      echo "Successfully installed WebView2 runtime"

      echo "Now, to finish off, installing vcrun2017, ole32 and mf is needed using winetricks"
      echo "For some reason, this will hang endlessly when ran in a script, but it will work when running manually in a terminal"
      echo "Run the following command in the terminal"
      echo "umu-run winetricks -q --force vcrun2017 ole32 mf"
      echo "Any errors during this installation regarding winemenubuilder can be ignored."
      echo "Additionally, it may be required to set Battle.net.exe and BlizzardBrowser.exe to Windows 7"
    '';
}
