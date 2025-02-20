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
          python = dev ++ [
            python3Packages.black
            python3Packages.isort
            python3Packages.mypy
            python3Packages.pyls-flake8
            python3Packages.pyls-isort
            python3Packages.python-lsp-black
            python3Packages.python-lsp-server
          ];
          desktop =
            dev
            ++ python
            ++ [
              blueman
              calibre
              cameractrls
              pkgs-stable.chromium # has to match GPU Drivers
              evince
              feh
              firefox
              hplip
              inkscape
              keepassxc
              killall
              kitty
              libreoffice
              mpc-cli
              mpd
              mpd-mpris
              numlockx
              paprefs
              pcsctools
              pinentry
              playerctl
              pstree
              rsync
              thunderbird
              typst
              vlc
              xclip
              xournalpp
              xsane
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
          paths = deps.python;
        };

        packages.desktop = pkgs.symlinkJoin {
          name = "Wonko's Desktop Tools";
          paths = deps.desktop;
        };

        apps.nix = {
            type = "app";
            program = "${pkgs.nix}/bin/nix";
        };
      }
    );
}
