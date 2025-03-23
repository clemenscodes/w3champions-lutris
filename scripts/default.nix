{
  self,
  inputs,
  pkgs,
  environment,
  ...
}: {
  battlenet = import ./battlenet {inherit self inputs pkgs environment;};
  bonjour = import ./bonjour {inherit self inputs pkgs environment;};
  w3champions = import ./w3champions {inherit self inputs pkgs environment;};
  warcraft = import ./warcraft {inherit self inputs pkgs environment;};
  webview2 = import ./webview2 {inherit self inputs pkgs environment;};
}
