{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "brendan";
  home.homeDirectory = "/Users/brendan";
  home.stateVersion = "21.05";

  home.packages = [
    pkgs.awscli2
    pkgs.direnv
    pkgs.git
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    pkgs.tree
  ];

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
