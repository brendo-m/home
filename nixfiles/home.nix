{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "brendan";
  home.homeDirectory = "/Users/brendan";
  home.stateVersion = "21.05";

  home.packages = with pkgs; [
    awscli2
    bat          # cat replacement written in rust
    direnv       # per-directory env vars
    diff-so-fancy # pretty diffs
    exa          # ls replacement written in rust
    fd           # find replacement written in rust
    git
    gnupg
    htop         # better version of top
    httpie       # alternative to curl
    jq           # json query
    pinentry_mac # Necessary for GPG
    ripgrep      # grep replacement written in rust
    tree         # display directory tree structure
    wget
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
