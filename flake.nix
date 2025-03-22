{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    umu = {
      url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    };
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [inputs.chaotic.overlays.default];
    };
    commonPkgs = [
      pkgs.wineWowPackages.stagingFull
      pkgs.wineWow64Packages.stagingFull
      pkgs.winetricks
      pkgs.gamescope
      pkgs.mangohud
      pkgs.curl
      pkgs.samba
      pkgs.jansson
      pkgs.gnutls
      pkgs.zenity
      pkgs.libsForQt5.kdialog
      pkgs.protobuf
      pkgs.python313Packages.protobuf
      pkgs.vulkanPackages_latest.vulkan-tools
      pkgs.dxvk
      pkgs.vkd3d
      pkgs.vkd3d-proton
      pkgs.libva
      pkgs.mesa_git
      pkgs.mesa32_git
    ];
    environment = ''
      ln -sf "$(which wine)" ./wine64
      PATH="$(pwd):$PATH"

      export VK_DRIVER_FILES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json"
      export VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.686.json"
      export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.local/share/Steam"
      export WINEPATH="$STEAM_COMPAT_CLIENT_INSTALL_PATH/steamapps/compatdata"
      export WINEPREFIX="$WINEPATH/w3champions"
      export WINE_SIMULATE_WRITECOPY=1
      export STEAM_COMPAT_DATA_PATH="$WINEPREFIX"
      export WINEDEBUG=+vulkan
      export WINEARCH=win64

      export DOWNLOADS="$WINEPREFIX/drive_c/users/$USER/Downloads"
      export PROGRAM_FILES="$WINEPREFIX/drive_c/Program Files"
      export PROGRAM_FILES86="$WINEPREFIX/drive_c/Program Files (x86)"
      export APPDATA="$WINEPREFIX/drive_c/users/$USER/AppData"
      export APPDATA_LOCAL="$APPDATA/Local"
      export APPDATA_ROAMING="$APPDATA/Roaming"

      export BATTLENET_URL="https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"
      export BNET_SETUP_EXE="$DOWNLOADS/BattleNet-Setup.exe"
      export BNET_EXE="$PROGRAM_FILES86/Battle.net/Battle.net.exe"
      export BNET_CONFIG_HOME="$APPDATA_ROAMING/Battle.net"
      export BNET_CONFIG="$BNET_CONFIG_HOME/Battle.net.config"

      export W3C_URL="https://update-service.w3champions.com/api/launcher-e"
      export W3C_SETUP_EXE="$DOWNLOADS/W3Champions_1.5.27_x64_en-US.msi"
      export W3C_EXE="$PROGRAM_FILES/W3Champions/W3Champions.exe"
      export W3C_APPDATA="$APPDATA_LOCAL/com.w3champions.client"

      export WEBVIEW2_URL="https://go.microsoft.com/fwlink/?linkid=2124703"
      export WEBVIEW2_SETUP_EXE="$DOWNLOADS/MicrosoftEdgeWebview2Setup.exe"

      export BONJOUR_URL="https://cdn.discordapp.com/attachments/797076711023050753/1347196008710279209/Bonjour64.msi?ex=67df60ce&is=67de0f4e&hm=3a3bf8c2cd770e6a795460004ebfafee0c59d04b03435decbfd9cf55b050fed7&"
      export BONJOUR_MSI="$DOWNLOADS/Bonjour64.msi"
      export BONJOUR_EXE="$PROGRAM_FILES/Bonjour/mDNSResponder.exe"
    '';
    w3champions = pkgs.writeShellApplication {
      name = "w3champions";
      runtimeInputs = commonPkgs;
      text =
        environment
        + ''
          if [ ! -d "$WINEPREFIX" ]; then
            echo "Initializing Wine prefix..."
            mkdir -p "$WINEPREFIX"
          else
            echo "Wine prefix already exists, skipping initialization."
          fi

          echo "Installing Arial font..."
          winetricks -q --force arial || true

          echo "Installing Tahoma font..."
          winetricks -q tahoma || true

          echo "Installing corefonts..."
          winetricks -q corefonts || true

          echo "Setting Windows 10 mode for wine"
          wine "$WINEPREFIX/drive_c/windows/regedit.exe" /S "${self}/registry/wine.reg"

          echo "Enabling DXVA2 for wine"
          wine "$WINEPREFIX/drive_c/windows/regedit.exe" /S "${self}/registry/dxva2.reg"

          mkdir -p "$DOWNLOADS"

          echo "Downloading WebView2 runtime installer..."
          curl -L "$WEBVIEW2_URL" -o "$WEBVIEW2_SETUP_EXE"

          echo "Installing the WebView2 runtime..."
          wine "$WEBVIEW2_SETUP_EXE" || exit 1

          echo "Installing d3dx10.dll for WebView2..."
          winetricks -q --force d3dx10 || true

          echo "Installing d3dx9.dll for WebView2..."
          winetricks -q --force d3dx9 || true

          echo "Installing dxvk.dll for WebView2..."
          winetricks -q --force dxvk || true

          echo "Installing vkd3d.dll for WebView2..."
          winetricks -q --force vkd3d || true

          echo "Installing d3dcompiler_42.dll for WebView2..."
          winetricks -q --force d3dcompiler_42 || true

          echo "Installing d3dcompiler_43.dll for WebView2..."
          winetricks -q --force d3dcompiler_43 || true

          echo "Installing d3dcompiler_46.dll for WebView2..."
          winetricks -q --force d3dcompiler_46 || true

          echo "Installing d3dcompiler_47.dll for WebView2..."
          winetricks -q --force d3dcompiler_47 || true

          echo "Installing d3drm.dll for WebView2..."
          winetricks -q --force d3drm || true

          echo "Installing d3dx10_43.dll for WebView2..."
          winetricks -q --force d3dx10_43 || true

          echo "Installing d3dx11_42.dll for WebView2..."
          winetricks -q --force d3dx11_42 || true

          echo "Setting 'msedgewebview2.exe' to Windows 7"
          wine "$WINEPREFIX/drive_c/windows/regedit.exe" /S "${self}/registry/msedgewebview2.exe.reg"

          echo "Successfully installed WebView2 runtime"

          echo "Installing Bonjour..."

          if [ ! -f "$BONJOUR_MSI" ]; then
            echo "Downloading Bonjour installer..."
            curl -L "$BONJOUR_URL" -o "$BONJOUR_MSI"
          else
            echo "Bonjour installer already downloaded."
          fi

          wine "$BONJOUR_MSI"

          if [ ! -f "$BONJOUR_EXE" ]; then
            echo "Failed installing Bonjour"
            exit 1
          fi

          echo "Running Bonjour..."

          wine net stop 'Bonjour Service'
          wine net start 'Bonjour Service'

          echo "Installing Battle.net..."

          if [ ! -f "$BNET_SETUP_EXE" ]; then
            echo "Downloading Battle.net launcher..."
            curl -L "$BATTLENET_URL" -o "$BNET_SETUP_EXE"
          else
            echo "Battle.net launcher already downloaded."
          fi

          echo "Writing a Battle.net config file"
          mkdir -p "$BNET_CONFIG_HOME"
          cat ${self}/assets/Battle.net.config.json > "$BNET_CONFIG"

          echo "Running Battle.net setup..."
          wine "$BNET_SETUP_EXE"

          if [[ ! -f "$BNET_EXE" ]]; then
            echo "Failed to install Battle.net"
            exit 1
          fi

          echo "Successfully installed Battle.net"

          echo "Setting 'Battle.net.exe' to Windows 7"
          wine "$WINEPREFIX/drive_c/windows/regedit.exe" /S "${self}/registry/Battle.net.exe.reg"

          echo "Installing W3Champions..."

          if [ ! -f "$W3C_SETUP_EXE" ]; then
              echo "Downloading W3Champions launcher..."
              curl -L "$W3C_URL" -o "$W3C_SETUP_EXE"
          else
              echo "W3Champions launcher already downloaded."
          fi

          echo "Running W3Champions setup..."
          echo "Do not yet launch W3Champions after the installer finishes... a final step will still be needed."
          wine "$W3C_SETUP_EXE" || exit 1

          echo "Successfully installed W3Champions"

          wineserver -k

          echo "Now, to finish off, installing vcrun2017 and ole32 is needed using winetricks"
          echo "For some reason, this will hang endlessly when ran in a script, but it will work when running manually in a terminal"
          echo "Run the following command in the terminal"
          echo "winetricks -q --force vcrun2017 ole32"
          echo "Any errors during this installation regarding winemenubuilder can be ignored."
        '';
    };
  in {
    packages = {
      ${system} = {
        inherit w3champions;
        default = self.packages.${system}.w3champions;
      };
    };
    devShells = {
      ${system} = {
        default = pkgs.mkShell {
          buildInputs = [w3champions] ++ commonPkgs;
          shellHook =
            environment
            + ''
              echo "Warcraft III + W3Champions environment loaded..."
            '';
        };
      };
    };
  };
}
