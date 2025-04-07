{
  description = "My nix os and dev env";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixos-hardware,
      flake-utils,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64";
      #       pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
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
          feh
          feh.man
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
        full = [
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
    {
      packages = forAllSystems (system: {
        dev = pkgs.symlinkJoin {
          name = "Wonko's Develop Tools";
          paths = deps.dev;
        };

        python = pkgs.symlinkJoin {
          name = "Wonko's Python Tools";
          paths = deps.python ++ deps.dev;
        };

        desktop = pkgs.symlinkJoin {
          name = "Wonko's Desktop Tools";
          paths = deps.desktop ++ deps.python ++ deps.dev;
        };

        full = pkgs.symlinkJoin {
          name = "All of Wonko's Tools";
          paths = deps.full ++ deps.desktop ++ deps.python ++ deps.dev;
        };
      });
      apps = forAllSystems (system: {
        nix = {
          description = "the nix version that install(ed) this flake";
          type = "app";
          program = "${pkgs.nix}/bin/nix";
        };
      });

      nixosConfigurations = {
        deepthought = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system inputs outputs;
          };
          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-e495
            ./os/hardware-configuration.nix
            ./os/configuration.nix
          ];
        };
      };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
