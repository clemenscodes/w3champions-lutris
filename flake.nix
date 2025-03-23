{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
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
      export VK_DRIVER_FILES="/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json:/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json"

      export WINEPATH="$HOME/.local/share/wineprefixes"
      export WINEPREFIX="$WINEPATH/w3champions"
      export WINEARCH=win64

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
        inherit (scripts) warcraft w3champions bonjour battlenet webview2;
        default = self.packages.${system}.warcraft;
      };
    };
    devShells = {
      ${system} = {
        default = pkgs.mkShell {
          buildInputs = [
            inputs.wine-overlays.packages.${system}.wine-wow64-staging-10_4
            inputs.wine-overlays.packages.${system}.wine-wow64-staging-winetricks-10_4
            pkgs.winetricks
            pkgs.curl
            pkgs.samba
            pkgs.jansson
            pkgs.gnutls
            pkgs.zenity
            pkgs.lutris
            umu
          ];
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
