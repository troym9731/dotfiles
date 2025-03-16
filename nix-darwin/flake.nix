{
  description = "My nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          nix.enable = false;

          nixpkgs.config.allowUnfree = true;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.alacritty
            pkgs.bat
            pkgs.bottom
            pkgs.bun
            pkgs.cloc
            pkgs.efm-langserver
            pkgs.fd
            pkgs.fx
            pkgs.fzf
            pkgs.gh
            pkgs.git
            pkgs.hugo
            pkgs.oh-my-posh
            pkgs.jq
            pkgs.mise
            pkgs.neovim
            pkgs.nixfmt-rfc-style
            pkgs.prettierd
            pkgs.ripgrep
            pkgs.terraform
            pkgs.tldr
            pkgs.tmux
            pkgs.tree
            pkgs.vim
            pkgs.wget
            pkgs.zoxide
            pkgs.zsh
            pkgs.zsh-syntax-highlighting
          ];

          homebrew = {
            enable = true;
            taps = [ "oven-sh/bun" ];
            brews = [
              # Needed for other dependencies
              "coreutils"
              "gpg"
              "automake"
              "autoconf"
              "openssl"
              "libyaml"
              "readline"
              "libtool"
              "unixodbc"
              "qt"
              # Standard brews
              "aider"
              "gnu-sed"
              "mas"
              "reattach-to-user-namespace"
            ];
            casks = [
              "1password"
              "bettertouchtool"
              "discord"
              "firefox"
              "ghostty"
              "google-chrome"
              "kap"
              "microsoft-teams"
              "raycast"
              "slack"
              "spotify"
              "visual-studio-code"
            ];
            masApps = {
              "Logic Pro" = 634148309;
            };
            onActivation.cleanup = "zap";
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
          };

          fonts.packages = [ pkgs.nerd-fonts.hasklug ];

          # Allows for sourcing zsh syntax highlighting
          environment.pathsToLink = [ "/share" ];

          programs.zsh = {
            enable = true;
            enableBashCompletion = false;
            enableCompletion = false;
            promptInit = "";
          };

          system.keyboard = {
            enableKeyMapping = true;
            remapCapsLockToControl = true;
          };

          system.defaults = {
            dock.autohide = true;
            dock.persistent-apps = [
              "/System/Applications/Messages.app"
              "/Applications/Google Chrome.app"
              "/Applications/Spotify.app"
              "/Applications/Discord.app"
              "/Applications/Ghostty.app"
            ];
            finder.FXPreferredViewStyle = "clmv";
            loginwindow.GuestEnabled = false;
            NSGlobalDomain.AppleInterfaceStyle = "Dark";
            NSGlobalDomain.ApplePressAndHoldEnabled = false;
            NSGlobalDomain.KeyRepeat = 2;
            NSGlobalDomain.InitialKeyRepeat = 20;
          };

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Troys-Personal-MacBook-Pro
      darwinConfigurations."Troys-Personal-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "troymullaney";
              autoMigrate = true;
            };
          }
        ];
      };
    };
}
