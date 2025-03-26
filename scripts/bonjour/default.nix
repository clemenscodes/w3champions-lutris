{
  self,
  inputs,
  pkgs,
  environment,
  ...
}:
pkgs.writeShellApplication {
  name = "bonjours";
  runtimeInputs = [
    self.packages.x86_64-linux.wine-ge
    pkgs.curl
  ];
  text =
    environment
    + ''
      echo "Restarting Bonjour..."

      wine net stop 'Bonjour Service'
      wine net start 'Bonjour Service'
    '';
}
