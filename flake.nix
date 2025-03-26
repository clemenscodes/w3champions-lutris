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
        pkgs.wineWowPackages.unstableFull
      ]
      ++ (with self.packages.${system}; [
        warcraft
        warcraft-legacy
        w3champions
        w3champions-legacy
        battlenet
        battlenet-legacy
        webview2
        lutris-install
        winetricks
        winetricks-legacy
        # wine-wow64-staging-10_4
        # wine-wow64-staging-winetricks-10_4
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
      export __EGL_VENDOR_LIBRARY_DIRS="/run/opengl-driver/share/glvnd/egl_vendor.d:/run/opengl-driver-32/share/glvnd/egl_vendor.d"
      export LIBVA_DRIVERS_PATH="/run/opengl-driver/lib/dri:/run/opengl-driver-32/lib/dri"
      export LIBVA_DRIVER_NAME="d3d12"
      export VDPAU_DRIVER_PATH="/run/opengl-driver/lib/vdpau:/run/opengl-driver-32/lib/vdpau"
      export VDPAU_DRIVER="d3d12"
      export VK_DRIVER_FILES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json"
      export VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json"
      export VULKAN_SDK="${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d"
      export VK_LAYER_PATH="${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d"

      export GST_PLUGIN_SYSTEM_PATH_1_0="${GST_PLUGIN_SYSTEM_PATH_1_0}"

      export WINEPATH="$HOME/.local/share/wineprefixes"
      export WINEPREFIX="$WINEPATH/w3champions"
      export WINEARCH="win64"
      export WINE_LARGE_ADDRESS_AWARE="1"
      export WINEDEBUG="-all"
      export WINEESYNC="1"
      export WINEFSYNC="1"

      export STEAM_COMPAT_DATA_PATH="$WINEPREFIX"
      export STEAM_COMPAT_SHADER_PATH="$WINEPREFIX/shadercache"
      export STEAM_LINUX_RUNTIME_VERBOSE="1"
      export STEAM_LINUX_RUNTIME_LOG="1"

      export DXVK_HUD="1"
      export DXVK_STATE_CACHE_PATH="$WINEPREFIX"
      export DXVK_LOG_LEVEL="info"
      export DXVK_LOG_PATH="$WINEPREFIX"
      export DXVK_CONFIGURATION_FILE="${self}/dxvk.conf"
      export STAGING_SHARED_MEMORY=1
      export __GL_SHADER_DISK_CACHE=1
      export __GL_SHADER_DISK_CACHE_PATH="$WINEPREFIX"

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

      rm ./wine64 || true
      ln -s "$(which wine)" ./wine64
      PATH="$(pwd):$PATH"
    '';
    environment-legacy = ''
      export __EGL_VENDOR_LIBRARY_DIRS="/run/opengl-driver/share/glvnd/egl_vendor.d:/run/opengl-driver-32/share/glvnd/egl_vendor.d"
      export LIBVA_DRIVERS_PATH="/run/opengl-driver/lib/dri:/run/opengl-driver-32/lib/dri"
      export LIBVA_DRIVER_NAME="d3d12"
      export VDPAU_DRIVER_PATH="/run/opengl-driver/lib/vdpau:/run/opengl-driver-32/lib/vdpau"
      export VDPAU_DRIVER="d3d12"
      export VK_DRIVER_FILES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json"
      export VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json"
      export VULKAN_SDK="${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d"
      export VK_LAYER_PATH="${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d"

      export GST_PLUGIN_SYSTEM_PATH_1_0="${GST_PLUGIN_SYSTEM_PATH_1_0}"

      export WINEPATH="$HOME/.local/share/wineprefixes"
      export WINEPREFIX="$WINEPATH/bnet"
      export WINEARCH="win64"
      export WINE_LARGE_ADDRESS_AWARE="1"
      export WINEDEBUG="-all"
      export WINEESYNC="1"
      export WINEFSYNC="1"

      export STEAM_COMPAT_DATA_PATH="$WINEPREFIX"
      export STEAM_COMPAT_SHADER_PATH="$WINEPREFIX/shadercache"
      export STEAM_LINUX_RUNTIME_VERBOSE="1"
      export STEAM_LINUX_RUNTIME_LOG="1"

      export DXVK_HUD="1"
      export DXVK_STATE_CACHE_PATH="$WINEPREFIX"
      export DXVK_LOG_LEVEL="info"
      export DXVK_LOG_PATH="$WINEPREFIX"
      export DXVK_CONFIGURATION_FILE="${self}/dxvk.conf"
      export STAGING_SHARED_MEMORY=1
      export __GL_SHADER_DISK_CACHE=1
      export __GL_SHADER_DISK_CACHE_PATH="$WINEPREFIX"

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

      rm ./wine64 || true
      ln -s "$(which wine)" ./wine64
      PATH="$(pwd):$PATH"
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
          lutris-install
          winetricks
          winetricks-legacy
          ;
        inherit
          (inputs.wine-overlays.packages.${system})
          wine-ge
          wine-wow64-staging-10_4
          wine-wow64-staging-winetricks-10_4
          ;
        default = self.packages.${system}.warcraft;
      };
    };
    devShells = {
      ${system} = {
        default = pkgs.mkShell {
          inherit buildInputs;
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
