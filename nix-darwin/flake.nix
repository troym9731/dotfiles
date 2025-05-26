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
      commonModule =
        { pkgs, ... }:
        {
          nix.enable = false;
          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
          nixpkgs.config.allowUnfree = true;

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.alacritty
            pkgs.bat
            pkgs.bottom
            pkgs.claude-code
            pkgs.cloc
            pkgs.efm-langserver
            pkgs.fd
            pkgs.fx
            pkgs.fzf
            pkgs.gh
            pkgs.git
            pkgs.oh-my-posh
            pkgs.jq
            pkgs.mise
            pkgs.neovim
            pkgs.nixfmt-rfc-style
            pkgs.ripgrep
            pkgs.tldr
            pkgs.tmux
            pkgs.tree
            pkgs.vim
            pkgs.wget
            pkgs.zoxide
            pkgs.zsh
            pkgs.zsh-syntax-highlighting
          ];

          # Allows for sourcing zsh syntax highlighting
          environment.pathsToLink = [ "/share" ];

          homebrew = {
            enable = true;
            brews = [
              # Needed for other dependencies
              "coreutils"
              "gpg"
              "openssl"
              # Standard brews
              "gnu-sed"
              "mas"
              "reattach-to-user-namespace"
            ];
            casks = [
              "1password"
              "bettertouchtool"
              "firefox"
              "ghostty"
              "google-chrome"
              "kap"
              "raycast"
              "slack"
              "spotify"
              "visual-studio-code"
            ];
            onActivation = {
              cleanup = "zap";
              autoUpdate = true;
              upgrade = true;
            };
          };

          fonts.packages = [ pkgs.nerd-fonts.hasklug ];

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
            loginwindow.GuestEnabled = false;
            finder = {
              FXPreferredViewStyle = "clmv";
              AppleShowAllExtensions = true;
            };
            NSGlobalDomain = {
              AppleInterfaceStyle = "Dark";
              ApplePressAndHoldEnabled = false;
              KeyRepeat = 2;
              InitialKeyRepeat = 20;
            };
            trackpad = {
              Clicking = true;
              TrackpadRightClick = true;
            };
          };

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Troys-Personal-MacBook-Pro
      darwinConfigurations = {
        "Troys-Personal-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          modules = [
            commonModule
            nix-homebrew.darwinModules.nix-homebrew
            (
              { pkgs, ... }:
              {
                system.primaryUser = "troymullaney";
                system.defaults.dock.persistent-apps = [
                  "/System/Applications/Messages.app"
                  "/Applications/Google Chrome.app"
                  "/Applications/Spotify.app"
                  "/Applications/Discord.app"
                  "/Applications/Ghostty.app"
                ];
                environment.systemPackages = [
                  pkgs.bun
                  pkgs.hugo
                  pkgs.terraform
                ];
                homebrew = {
                  casks = [
                    "discord"
                    "microsoft-teams"
                  ];
                  masApps = {
                    "Logic Pro" = 634148309;
                  };
                };
                nix-homebrew = {
                  enable = true;
                  enableRosetta = true;
                  user = "troymullaney";
                  autoMigrate = true;
                };
              }
            )
          ];
        };

        "Troys-Work-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          modules = [
            commonModule
            nix-homebrew.darwinModules.nix-homebrew
            (
              { pkgs, ... }:
              {
                system.primaryUser = "";
                system.defaults.dock.persistent-apps = [
                  "/Applications/Google Chrome.app"
                  "/Applications/Spotify.app"
                  "/Applications/Ghostty.app"
                ];
                nix-homebrew = {
                  enable = true;
                  enableRosetta = true;
                  user = "";
                  autoMigrate = true;
                };
              }
            )
          ];
        };
      };
    };
}
