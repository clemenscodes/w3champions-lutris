{
  nixConfig = {
    extra-substituters = ["https://nix-gaming.cachix.org"];
    extra-trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
    };
    umu = {
      url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    lutris-overlay = {
      url = "github:clemenscodes/lutris-overlay";
    };
    wine-overlays = {
      url = "github:clemenscodes/wine-overlays";
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
      overlays = [
        inputs.wine-overlays.overlays.wine-10_4
        inputs.lutris-overlay.overlays.lutris
      ];
    };
    scripts = import ./scripts {inherit self inputs pkgs environment;};
    umu = inputs.umu.packages.${system}.default.override {
      extraPkgs = pkgs: [];
      extraLibraries = pkgs: [];
      withMultiArch = true;
      withTruststore = true;
      withDeltaUpdates = true;
    };
    environment = ''
      # [ -f ./wine64 ] && rm ./wine64
      # ln -s "$(which wine)" ./wine64
      # PATH="$(pwd):$PATH"

      export VK_DRIVER_FILES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json"
      export VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json"
      export DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1

      # export WINEPATH="$HOME/.local/share/wineprefixes"
      export WINEPATH="$HOME/Games"
      export WINEPREFIX="$WINEPATH/w3champions"
      export WINE="${inputs.wine-overlays.packages.${system}.wine-wow64-staging-winetricks-10_4}/bin/wine64"
      export WINEARCH=win64
      export WINEESYNC=1
      export WINEFSYNC=1
      export WINEDEBUG=-all
      # export WINEDLLOVERRIDES="d3d10core,d3d11,d3d12,d3d9,d3dcompiler_42,d3dcompiler_43,d3dcompiler_46,d3dcompiler_47,d3dx10,d3dx10_33,d3dx10_34,d3dx10_35,d3dx10_36,d3dx10_37,d3dx10_38,d3dx10_39,d3dx10_40,d3dx10_41,d3dx10_42,d3dx10_43,d3dx11_42,d3dx11_43,d3dx9_24,d3dx9_25,d3dx9_26,d3dx9_27,d3dx9_28,d3dx9_29,d3dx9_30,d3dx9_31,d3dx9_32,d3dx9_33,d3dx9_34,d3dx9_35,d3dx9_36,d3dx9_37,d3dx9_38,d3dx9_39,d3dx9_40,d3dx9_41,d3dx9_42,d3dx9_43,dxgi,nvapi,nvapi64,nvml=n;winemenubuilder="
      # export WINE_LARGE_ADDRESS_AWARE=1
      # export WINE_FULLSCREEN_FSR=1
      # export STAGING_SHARED_MEMORY=1
      # export DXVK_HUD=1
      # export DXVK_NVAPIHACK=0
      # export DXVK_ENABLE_NVAPI=1
      # export DXVK_LOG_LEVEL="info"
      #
      export DOWNLOADS="$WINEPREFIX/drive_c/users/$USER/Downloads"
      export PROGRAM_FILES="$WINEPREFIX/drive_c/Program Files"
      export PROGRAM_FILES86="$WINEPREFIX/drive_c/Program Files (x86)"
      export APPDATA="$WINEPREFIX/drive_c/users/$USER/AppData"
      export APPDATA_LOCAL="$APPDATA/Local"
      export APPDATA_ROAMING="$APPDATA/Roaming"

      export WEBVIEW2_URL="https://go.microsoft.com/fwlink/?linkid=2124703"
      export WEBVIEW2_SETUP_EXE="$DOWNLOADS/MicrosoftEdgeWebview2Setup.exe"

      export BONJOUR_URL="https://cdn.discordapp.com/attachments/797076711023050753/1347196008710279209/Bonjour64.msi?ex=67df60ce&is=67de0f4e&hm=3a3bf8c2cd770e6a795460004ebfafee0c59d04b03435decbfd9cf55b050fed7&"
      export BONJOUR_MSI="$DOWNLOADS/Bonjour64.msi"
      export BONJOUR_EXE="$PROGRAM_FILES/Bonjour/mDNSResponder.exe"

      export BATTLENET_URL="https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"
      export BNET_SETUP_EXE="$DOWNLOADS/BattleNet-Setup.exe"
      export BNET_EXE="$PROGRAM_FILES86/Battle.net/Battle.net.exe"
      export BNET_CONFIG_HOME="$APPDATA_ROAMING/Battle.net"
      export BNET_CONFIG="$BNET_CONFIG_HOME/Battle.net.config"

      export W3C_URL="https://update-service.w3champions.com/api/launcher-e"
      export W3C_SETUP_EXE="$DOWNLOADS/W3Champions_1.5.27_x64_en-US.msi"
      export W3C_EXE="$PROGRAM_FILES/W3Champions/W3Champions.exe"
      export W3C_APPDATA="$APPDATA_LOCAL/com.w3champions.client"
    '';
  in {
    packages = {
      ${system} = {
        inherit
          (scripts)
          warcraft
          w3champions
          bonjour
          battlenet
          webview2
          lutris-install
          ;
        inherit (inputs.nix-gaming.packages.${system}) wine-ge wine-osu wine-tkg;
        inherit umu;
        default = self.packages.${system}.lutris-install;
      };
    };
    devShells = {
      ${system} = {
        default = pkgs.mkShell {
          buildInputs =
            [
              # inputs.wine-overlays.packages.${system}.wine-wow-staging-10_4
              # inputs.wine-overlays.packages.${system}.wine-wow64-staging-10_4
              # inputs.wine-overlays.packages.${system}.wine-wow64-staging-winetricks-10_4
              pkgs.winetricks
              pkgs.curl
              pkgs.samba
              pkgs.jansson
              pkgs.gnutls
              pkgs.zenity
              pkgs.lutris
              pkgs.mesa
              pkgs.driversi686Linux.mesa
              umu
            ]
            ++ (with self.packages.${system}; [
              warcraft
              w3champions
              bonjour
              battlenet
              webview2
              lutris-install
              # wine-tkg
              wine-ge
              # wine-osu
            ]);
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
