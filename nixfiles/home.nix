{ config, pkgs, lib, ... }:

let
  python = import ./python.nix;
in
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      # https://github.com/nmattia/niv/issues/332#issuecomment-958449218
      niv =
        self.haskell.lib.compose.overrideCabal
          (drv: { enableSeparateBinOutput = false; })
          super.haskellPackages.niv;
    })
  ];

  home.username = "brendan";
  home.homeDirectory = "/Users/brendan";
  home.stateVersion = "21.05";

  home.packages = with pkgs; [
    awscli2
    bat          # cat replacement written in rust
    diff-so-fancy # pretty diffs
    exa          # ls replacement written in rust
    fd           # find replacement written in rust
    git
    gnupg
    htop         # better version of top
    httpie       # alternative to curl
    jq           # json query
    just
    ngrok        # Expose local HTTP stuff publicly
    pinentry_mac # Necessary for GPG
    ripgrep      # grep replacement written in rust
    rustup
    tree         # display directory tree structure
    wget

    # python
    python

    (callPackage ./scala-cli.nix {})

    nodejs
    yarn
  ];

  home.file.".vimrc".source = ./vimrc;

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.java = {
    enable = true; 
    package = pkgs.jdk17; 
  };

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-surround vim-sneak vim-airline ];

    extraConfig = builtins.readFile ./vimrc;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -lah";
      h = "history";
      c = "clear";

      ga = "git add";
      gd = "git diff";
      gg = "git prettyLog";
      gs = "git status";
      gca = "git commit --amend";
      gl = "git pull";
      gfa = "git fetch --all";

      pj = "npx projen";
      pjb = "npx projen build";
      pjc = "npx projen compile";
      pjt = "npx projen test";
      pjw = "npx projen watch";

      crg = "cargo";

      nix-switch = "home-manager switch && . ~/.zshrc";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  
    oh-my-zsh = {
      enable = true;
      plugins = [ 
        "git" 
      ];
    };

    # https://matthewrhone.dev/nixos-npm-globally
    initExtra = ''
    export PATH=$PATH:$HOME/bin
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    export PATH=$PATH:$HOME/.local/bin
    export PATH=$PATH:$HOME/.cargo/bin
    export PATH=$PATH:/opt/homebrew/bin
    export PATH=$PATH:/usr/local/bin
    export PATH=$PATH:$HOME/.npm-packages/bin

    export NODE_PATH=$HOME/.npm-packages/lib/node_modules

    sso() {
      unset AWS_PROFILE
      export AWS_PROFILE=$1
      aws sts get-caller-identity &> /dev/null || aws sso login || (
        unset AWS_PROFILE && aws-configure-sso-profile --profile $1
      )
      eval $(aws-export-credentials --env-export)
    }
    '';
  };

  programs.git = {
    enable = true;
    userName  = "Brendan McKee";
    userEmail = "brendan.mckee@outlook.com";
    aliases = {
      prettylog = "log --graph --pretty='%Cblue%h%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset -%C(yellow)%d%Creset' --all";
    };
    extraConfig = {
      core.editor = "vim";
      pull.rebase = true;
      init.defaultBranch = "main";
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        syntax-theme = "base16";
      };
    };
  };

  programs.vscode = {
    enable = true;
  };
}
