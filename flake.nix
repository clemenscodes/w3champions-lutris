{
  nixConfig = {
    extra-substituters = ["https://nix-gaming.cachix.org"];
    extra-trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    lutris-overlay = {
      url = "github:clemenscodes/lutris-overlay";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    wine-overlays = {
      url = "github:clemenscodes/wine-overlays";
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
    inherit (pkgs) lib;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        inputs.wine-overlays.overlays.wine-10_4
        inputs.lutris-overlay.overlays.lutris
      ];
    };
    scripts = import ./scripts {inherit self inputs pkgs environment environment-legacy;};
    buildInputs =
      [
        pkgs.curl
        pkgs.samba
        pkgs.jansson
        pkgs.gnutls
        pkgs.zenity
        pkgs.lutris
        pkgs.libdrm
        pkgs.libva
        pkgs.libva-utils
        pkgs.mesa
        pkgs.pkgsi686Linux.mesa
        pkgs.krb5
        pkgs.glfw3
        pkgs.glslang
        pkgs.renderdoc
        pkgs.spirv-tools
        pkgs.vulkan-volk
        pkgs.vulkan-tools
        pkgs.vulkan-loader
        pkgs.vulkan-headers
        pkgs.vulkan-validation-layers
        pkgs.vulkan-tools-lunarg
        pkgs.vulkan-extension-layer
      ]
      ++ (with self.packages.${system}; [
        warcraft
        warcraft-legacy
        w3champions
        w3champions-legacy
        battlenet
        battlenet-legacy
        webview2
        lutris-w3c
        msvproc
        winetricks
        winetricks-legacy
        wine-wow64-staging-10_4
        wine-wow64-staging-winetricks-10_4
      ]);
    GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
      pkgs.gst_all_1.gst-plugins-base
      pkgs.pkgsi686Linux.gst_all_1.gst-plugins-base
      pkgs.gst_all_1.gst-plugins-good
      pkgs.pkgsi686Linux.gst_all_1.gst-plugins-good
      pkgs.gst_all_1.gst-plugins-bad
      pkgs.pkgsi686Linux.gst_all_1.gst-plugins-bad
      pkgs.gst_all_1.gst-plugins-ugly
      pkgs.pkgsi686Linux.gst_all_1.gst-plugins-ugly
      pkgs.gst_all_1.gst-libav
      pkgs.pkgsi686Linux.gst_all_1.gst-libav
      pkgs.gst_all_1.gst-vaapi
      pkgs.pkgsi686Linux.gst_all_1.gst-vaapi
    ];
    environment = ''
      export WINEPATH="$HOME/Games"
      export WINEPREFIX="$WINEPATH/w3champions"
      export WINEARCH="win64"
      export WINEDEBUG="-all"

      export DOWNLOADS="$WINEPREFIX/drive_c/users/$USER/Downloads"
      export PROGRAM_FILES="$WINEPREFIX/drive_c/Program Files"
      export PROGRAM_FILES86="$WINEPREFIX/drive_c/Program Files (x86)"
      export APPDATA="$WINEPREFIX/drive_c/users/$USER/AppData"
      export APPDATA_LOCAL="$APPDATA/Local"
      export APPDATA_ROAMING="$APPDATA/Roaming"

      export WEBVIEW2_URL="https://go.microsoft.com/fwlink/?linkid=2124701"
      export WEBVIEW2_SETUP_EXE="$DOWNLOADS/MicrosoftEdgeWebview2Setup.exe"

      export BATTLENET_URL="https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"
      export BNET_SETUP_EXE="$DOWNLOADS/BattleNet-Setup.exe"
      export BNET_EXE="$PROGRAM_FILES86/Battle.net/Battle.net.exe"
      export BNET_CONFIG_HOME="$APPDATA_ROAMING/Battle.net"
      export BNET_CONFIG="$BNET_CONFIG_HOME/Battle.net.config"

      export W3C_URL="https://update-service.w3champions.com/api/launcher-e"
      export W3C_LEGACY_URL="https://update-service.w3champions.com/api/launcher/win"
      export W3C_SETUP_EXE="$DOWNLOADS/W3Champions_1.5.27_x64_en-US.msi"
      export W3C_LEGACY_SETUP_EXE="$DOWNLOADS/w3c-setup.exe"
      export W3C_EXE="$PROGRAM_FILES/W3Champions/W3Champions.exe"
      export W3C_LEGACY_EXE="$WINEPREFIX/drive_c/users/$USER/AppData/Local/Programs/w3champions/w3champions.exe"
      export W3C_APPDATA="$APPDATA_LOCAL/com.w3champions.client"

      export WARCRAFT_HOME="$PROGRAM_FILES86/Warcraft III"
    '';
    environment-legacy = ''
      export WINEPATH="$HOME/Games"
      export WINEPREFIX="$WINEPATH/bnet"
      export WINEARCH="win64"

      export DOWNLOADS="$WINEPREFIX/drive_c/users/$USER/Downloads"
      export PROGRAM_FILES="$WINEPREFIX/drive_c/Program Files"
      export PROGRAM_FILES86="$WINEPREFIX/drive_c/Program Files (x86)"
      export APPDATA="$WINEPREFIX/drive_c/users/$USER/AppData"
      export APPDATA_LOCAL="$APPDATA/Local"
      export APPDATA_ROAMING="$APPDATA/Roaming"

      export WEBVIEW2_URL="https://go.microsoft.com/fwlink/?linkid=2124701"
      export WEBVIEW2_SETUP_EXE="$DOWNLOADS/MicrosoftEdgeWebview2Setup.exe"

      export BATTLENET_URL="https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"
      export BNET_SETUP_EXE="$DOWNLOADS/BattleNet-Setup.exe"
      export BNET_EXE="$PROGRAM_FILES86/Battle.net/Battle.net.exe"
      export BNET_CONFIG_HOME="$APPDATA_ROAMING/Battle.net"
      export BNET_CONFIG="$BNET_CONFIG_HOME/Battle.net.config"

      export W3C_URL="https://update-service.w3champions.com/api/launcher-e"
      export W3C_LEGACY_URL="https://update-service.w3champions.com/api/launcher/win"
      export W3C_SETUP_EXE="$DOWNLOADS/W3Champions_1.5.27_x64_en-US.msi"
      export W3C_LEGACY_SETUP_EXE="$DOWNLOADS/w3c-setup.exe"
      export W3C_EXE="$PROGRAM_FILES/W3Champions/W3Champions.exe"
      export W3C_LEGACY_EXE="$WINEPREFIX/drive_c/users/$USER/AppData/Local/Programs/w3champions/w3champions.exe"
      export W3C_APPDATA="$APPDATA_LOCAL/com.w3champions.client"

      export WARCRAFT_HOME="$PROGRAM_FILES86/Warcraft III"
    '';
  in {
    packages = {
      ${system} = {
        inherit
          (scripts)
          warcraft
          warcraft-legacy
          w3champions
          w3champions-legacy
          battlenet
          battlenet-legacy
          webview2
          lutris-w3c
          msvproc
          winetricks
          winetricks-legacy
          ;
        inherit
          (inputs.wine-overlays.packages.${system})
          wine-ge
          wine-wow64-staging-10_4
          wine-wow64-staging-winetricks-10_4
          ;
        default = self.packages.${system}.lutris-w3c;
      };
    };
    devShells = {
      ${system} = {
        default = pkgs.mkShell {
          inherit buildInputs GST_PLUGIN_SYSTEM_PATH_1_0;
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
