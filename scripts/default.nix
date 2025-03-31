{
  self,
  inputs,
  pkgs,
  environment,
  environment-legacy,
  ...
}: {
  battlenet = import ./battlenet {inherit self inputs pkgs environment;};
  battlenet-legacy = import ./battlenet-legacy {inherit self inputs pkgs environment-legacy;};
  lutris-w3c = import ./lutris-w3c {inherit self inputs pkgs environment;};
  msvproc = import ./msvproc {inherit self inputs pkgs environment;};
  w3champions = import ./w3champions {inherit self inputs pkgs environment;};
  w3champions-legacy = import ./w3champions-legacy {inherit self inputs pkgs environment-legacy;};
  warcraft = import ./warcraft {inherit self inputs pkgs environment;};
  warcraft-legacy = import ./warcraft-legacy {inherit self inputs pkgs environment-legacy;};
  webview2 = import ./webview2 {inherit self inputs pkgs environment;};
  winetricks = import ./winetricks {inherit self inputs pkgs environment;};
  winetricks-legacy = import ./winetricks-legacy {inherit self inputs pkgs environment-legacy;};
}
