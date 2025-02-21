{
  description = "The Packages I need";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils?ref=c1dfcf08411b08f6b8615f7d8971a2bfa81d5e8a";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/24.05";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pkgs-stable = nixpkgs-stable.legacyPackages.${system};

        deps = with pkgs; rec {
          dev = [
            bash-completion
            colordiff
            curl
            direnv
            file
            pstree
            git
            gnumake
            gnupg
            jq
            nix
            neovim
            neovim-remote
            nixfmt-rfc-style
            python3
            python3Packages.pynvim
            ripgrep
            sqlite
            universal-ctags
            unixtools.xxd
            unzip
            wget
          ];
          python = [
            python3Packages.black
            python3Packages.isort
            python3Packages.mypy
            python3Packages.pyls-flake8
            python3Packages.pyls-isort
            python3Packages.python-lsp-black
            python3Packages.python-lsp-server
          ];
          desktop = [
              evince
              feh feh.man
              firefox
              keepassxc
              killall
              kitty
              paprefs
              pstree
              rsync
              vlc
              xclip
          ];
          full =
            [
              blueman
              calibre
              cameractrls
              pkgs-stable.chromium # has to match GPU Drivers
              inkscape
              libreoffice
              mpc-cli
              mpd
              mpd-mpris
              numlockx
              pcsctools
              pinentry
              playerctl
              thunderbird
              typst
              xournalpp
              zbar
            ];
        };
      in
      rec {
        packages.dev = pkgs.symlinkJoin {
          name = "Wonko's Develop Tools";
          paths = deps.dev;
        };

        packages.python = pkgs.symlinkJoin {
          name = "Wonko's Python Tools";
          paths = deps.python ++ deps.dev;
        };

        packages.desktop = pkgs.symlinkJoin {
          name = "Wonko's Desktop Tools";
          paths = deps.desktop ++ deps.python ++ deps.dev;
        };

        packages.full = pkgs.symlinkJoin {
          name = "All of Wonko's Tools";
          paths = deps.full ++ deps.desktop ++ deps.python ++ deps.dev;
        };

        apps.nix = {
            type = "app";
            program = "${pkgs.nix}/bin/nix";
        };
      }
    );
}
