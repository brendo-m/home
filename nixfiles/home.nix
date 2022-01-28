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

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-surround vim-sneak vim-airline ];
    extraConfig = ''
      syntax on
      set ruler
      set number
      set cursorline

      " Disable Arrow keys in Normal mode
      map <up> <nop>
      map <down> <nop>
      map <left> <nop>
      map <right> <nop>

      " Disable Arrow keys in Insert mode
      imap <up> <nop>
      imap <down> <nop>
      imap <left> <nop>
      imap <right> <nop>
    '';
  };
}
