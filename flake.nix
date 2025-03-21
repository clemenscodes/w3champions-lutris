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
      overlays = let
        mkWinePkgs = {
          final,
          prev,
          version,
          src,
          ...
        }: {
          "wine-bleeding-${version}" = prev.winePackages.unstableFull.overrideAttrs (oldAttrs: rec {
            inherit version src;
            name = "wine-bleeding-${version}";
          });
          "wine-bleeding-winetricks-${version}" = prev.stdenv.mkDerivation {
            name = "wine-bleeding-winetricks-${version}";
            phases = "installPhase";
            installPhase = ''
              mkdir -p $out/bin
              ln -s ${final."wine-bleeding-${version}"}/bin/wine $out/bin/wine64
            '';
          };
          "wine64-bleeding-${version}" = prev.wine64Packages.unstableFull.overrideAttrs (oldAttrs: rec {
            inherit version src;
            name = "wine64-bleeding-${version}";
          });
          "wine64-bleeding-winetricks-${version}" = prev.stdenv.mkDerivation {
            name = "wine64-bleeding-winetricks-${version}";
            phases = "installPhase";
            installPhase = ''
              mkdir -p $out/bin
              ln -s ${final."wine64-bleeding-${version}"}/bin/wine $out/bin/wine64
            '';
          };
          "wine-wow-bleeding-${version}" = prev.wineWowPackages.unstableFull.overrideAttrs (oldAttrs: rec {
            inherit version src;
            name = "wine-wow-bleeding-${version}";
          });
          "wine-wow-bleeding-winetricks-${version}" = prev.stdenv.mkDerivation {
            name = "wine-wow-bleeding-winetricks-${version}";
            phases = "installPhase";
            installPhase = ''
              mkdir -p $out/bin
              ln -s ${final."wine-wow-bleeding-${version}"}/bin/wine $out/bin/wine64
            '';
          };
          "wine-wow64-bleeding-${version}" = prev.wineWow64Packages.unstableFull.overrideAttrs (oldAttrs: rec {
            inherit version src;
            name = "wine-wow64-bleeding-${version}";
          });
          "wine-wow64-bleeding-winetricks-${version}" = prev.stdenv.mkDerivation {
            name = "wine-wow64-bleeding-winetricks-${version}";
            phases = "installPhase";
            installPhase = ''
              mkdir -p $out/bin
              ln -s ${final."wine-wow64-bleeding-${version}"}/bin/wine $out/bin/wine64
            '';
          };
        };
      in [
        (
          final: prev: let
            version = "10.3";
            src = prev.fetchurl rec {
              inherit version;
              url = "https://dl.winehq.org/wine/source/10.x/wine-${version}.tar.xz";
              hash = "sha256-3j2I/wBWuC/9/KhC8RGVkuSRT0jE6gI3aOBBnDZGfD4=";
            };
          in
            mkWinePkgs {inherit final prev version src;}
        )
        (
          final: prev: {
            lutris = prev.lutris.override {
              extraPkgs = pkgs: lutrisPkgs;
              extraLibraries = pkgs: lutrisPkgs;
              steamSupport = false;
            };
            wine-ge = inputs.nix-gaming.packages.${system}.wine-ge;
            umu = inputs.umu.packages.${system}.default.override {
              extraPkgs = pkgs: [];
              extraLibraries = pkgs: [];
              withMultiArch = true;
              withTruststore = true;
              withDeltaUpdates = true;
            };
          }
        )
        (inputs.chaotic.overlays.default)
      ];
    };
    lutrisPkgs = commonPkgs;
    commonPkgs = [
      # pkgs.winetricks
      # pkgs.proton-ge-custom
      # pkgs.python3
      # pkgs.wine-ge
      # pkgs.wine
      # pkgs.wine64
      # pkgs."wine-wow-bleeding-10.3"
      # pkgs."wine-wow-bleeding-winetricks-10.3"
      # pkgs."wine-wow64-bleeding-10.3"
      # pkgs."wine-wow64-bleeding-winetricks-10.3"
      # pkgs.wineWowPackages.unstableFull
      # pkgs.wineWow64Packages.unstableFull
      # pkgs.wineWowPackages.waylandFull
      pkgs.gamescope
      pkgs.mangohud
      pkgs.curl
      pkgs.samba
      pkgs.jansson
      pkgs.gnutls
      pkgs.zenity
      pkgs.libsForQt5.kdialog

      # pkgs.libdrm_git
      # pkgs.libdrm32_git
      # pkgs.vulkanPackages_latest.gfxreconstruct
      # pkgs.vulkanPackages_latest.glslang
      # pkgs.vulkanPackages_latest.spirv-cross
      # pkgs.vulkanPackages_latest.spirv-headers
      # pkgs.vulkanPackages_latest.spirv-tools
      # pkgs.vulkanPackages_latest.vulkan-extension-layer
      # pkgs.vulkanPackages_latest.vulkan-headers
      # pkgs.vulkanPackages_latest.vulkan-loader
      pkgs.vulkanPackages_latest.vulkan-tools
      # pkgs.vulkanPackages_latest.vulkan-tools-lunarg BROKEN when I compiled this on 21.03.2025
      # pkgs.vulkanPackages_latest.vulkan-utility-libraries
      # pkgs.vulkanPackages_latest.vulkan-validation-layers
      # pkgs.vulkanPackages_latest.vulkan-volk
      # pkgs.latencyflex-vulkan
      # pkgs.protobuf
      # pkgs.python313Packages.protobuf
      # pkgs.clinfo
      # pkgs.glxinfo
      # pkgs.glmark2
      # pkgs.libva-utils
      # pkgs.vulkan-tools
      # pkgs.dxvk
      # pkgs.vkd3d-proton
      # pkgs.rocmPackages.rocminfo
      # pkgs.rocmPackages.clr
      # pkgs.rocmPackages.clr.icd
      # pkgs.rocmPackages.rocm-smi
      # pkgs.rocmPackages.rocm-runtime
      # pkgs.amdvlk
      # pkgs.libva
      # pkgs.mesa
      # pkgs.driversi686Linux.amdvlk
      # pkgs.driversi686Linux.mesa
      pkgs.mesa_git
      pkgs.mesa32_git
      # pkgs.mesa_git.opencl
      # pkgs.intel-media-driver
      # pkgs.vaapiIntel
      # pkgs.rocmPackages.clr
      # pkgs.rocmPackages.clr.icd
      # pkgs.rocmPackages.rocm-runtime
      # pkgs.pkgsi686Linux.mesa32_git.opencl
      # pkgs.pkgsi686Linux.intel-media-driver
      # pkgs.pkgsi686Linux.vaapiIntel
    ];
    environment = ''
      # ln -sf "$(which wine)" ./wine64
      # PATH="$(pwd):$PATH"
      # export VK_DRIVER_FILES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json"
      # export VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.686.json"
      # export VK_DRIVER_FILES="/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json:/run/opengl-driver-32/share/vulkan/icd.d/amd_icd32.json"
      # export VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json:/run/opengl-driver-32/share/vulkan/icd.d/amd_icd32.json"
      # export LD_LIBRARY_PATH="/run/opengl-driver/lib:/run/opengl-driver-32/lib:${pkgs.mesa_git}/lib:${pkgs.mesa32_git}/lib:${pkgs.proton-ge-custom}/bin/files/lib:${pkgs.proton-ge-custom}/bin/files/lib64"
      # export STEAM_EXTRA_COMPAT_TOOLS_PATH="${pkgs.proton-ge-custom}/bin:$STEAM_EXTRA_COMPAT_TOOLS_PATH"
      export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.local/share/Steam"
      export WINEPATH="$STEAM_COMPAT_CLIENT_INSTALL_PATH/steamapps/compatdata"
      export WINEPREFIX="$WINEPATH/w3champions"
      # export WINE_SIMULATE_WRITECOPY=1
      # export STEAM_COMPAT_DATA_PATH="$WINEPREFIX"
      # export WINEDEBUG=+vulkan
      export WINEARCH=win64
      # export WINEESYNC=1
      # export PROTON_LOG=1
      # export PROTON_NO_FSYNC=1
      export PROTON_VERB=runinprefix
      # export LUTRIS_RUNTIME=0
      export GAMEID=umu-default
      # export DXVK_STATE_CACHE_PATH="$WINEPREFIX"
      # export STAGING_SHARED_MEMORY=1
      # export __GL_SHADER_DISK_CACHE=1
      # export __GL_SHADER_DISK_CACHE_PATH="$WINEPREFIX"
      # export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
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
    '';
    w3champions = pkgs.writeShellApplication {
      name = "w3champions";
      runtimeInputs = [pkgs.umu pkgs.lutris pkgs.curl] ++ lutrisPkgs;
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
          umu-run winetricks -q --force arial || true
          echo "Installing Tahoma font..."
          umu-run winetricks -q tahoma || true
          echo "Setting Windows 10 mode for wine"
          umu-run "$WINEPREFIX/drive_c/windows/regedit.exe" /S ${self}/registry/wine.reg
          echo "Enabling DXVA2 for wine"
          umu-run "$WINEPREFIX/drive_c/windows/regedit.exe" /S ${self}/registry/dxva2.reg
          mkdir -p "$DOWNLOADS"
          if [[ ! -d "$WINEPREFIX" || ! -f "$BNET_EXE" ]]; then
            echo "Installing Battle.net..."
            if [ ! -f "$BNET_SETUP_EXE" ]; then
              echo "Downloading Battle.net Launcher..."
              curl -L "$BATTLENET_URL" -o "$BNET_SETUP_EXE"
            else
              echo "Battle.net Launcher already downloaded."
            fi
            echo "Writing a Battle.net config file"
            mkdir -p "$BNET_CONFIG_HOME"
            cat ${self}/assets/Battle.net.config.json > "$BNET_CONFIG"
            umu-run "$BNET_SETUP_EXE" || exit 1
            echo "Successfully installed Battle.net"
          fi
          if [[ ! -d "$WINEPREFIX" || ! -f "$WEBVIEW2_SETUP_EXE" ]]; then
            echo "Downloading WebView2 runtime installer..."
            curl -L "$WEBVIEW2_URL" -o "$WEBVIEW2_SETUP_EXE"
            echo "Installing corefonts for WebView2..."
            umu-run winetricks -q corefonts || true
            echo "Installing ole32.dll for WebView2..."
            umu-run winetricks -q ole32 || true
            echo "Installing vcrun2017 for WebView2..."
            umu-run winetricks -q vcrun2017 || true
            echo "Installing the WebView2 runtime..."
            umu-run "$WEBVIEW2_SETUP_EXE" || exit 1
            echo "Setting msedgewebvie2.exe to Windows 7"
            umu-run "$WINEPREFIX/drive_c/windows/regedit.exe" /S ${self}/registry/msedgewebview2.exe.reg
            echo "Successfully installed WebView2 runtime"
          fi
          if [[ ! -d "$WINEPREFIX" || ! -f "$W3C_EXE" ]]; then
            echo "Installing W3Champions..."
            if [ ! -f "$W3C_SETUP_EXE" ]; then
                echo "Downloading W3Champions Launcher..."
                curl -L "$W3C_URL" -o "$W3C_SETUP_EXE"
            else
                echo "W3Champions Launcher already downloaded."
            fi
            umu-run "$W3C_SETUP_EXE" || exit 1
            echo "Successfully installed W3Champions"
          fi
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
          buildInputs =
            [
              pkgs.curl
              pkgs.winetricks
              pkgs.umu
              pkgs.lutris
              # pkgs.wineWowPackages.unstableFull
            ]
            ++ commonPkgs
            ++ lutrisPkgs;
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
