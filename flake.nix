{
    description = "My nix os and dev env";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgsStable.url = "github:NixOS/nixpkgs/25.05";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        treefmt-nix.url = "github:numtide/treefmt-nix";
        rust-overlay.url = "github:oxalica/rust-overlay";
    };
    outputs =
        {
            self,
            nixpkgs,
            nixpkgsStable,
            nixos-hardware,
            flake-utils,
            rust-overlay,
            ...
        }@inputs:
        let
            depsel =
                pkgs: with pkgs; let
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
                        nil
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
                        chromium # has to match GPU Drivers
                        inkscape
                        libreoffice
                        mpc
                        mpd
                        mpd-mpris
                        numlockx
                        pcsc-tools
                        pinentry-gnome3
                        playerctl
                        steam
                        thunderbird
                        typst
                        xournalpp
                        zbar
                    ];
                    in 
                     {inherit dev python desktop full;
                     all = dev ++ python ++ desktop ++ full;
                     };
        in
        flake-utils.lib.eachDefaultSystem (
            system:
            let
                pkgs = import nixpkgs {
                    inherit system;
                    overlays = [ (import rust-overlay) ];
                    config.allowUnfree = true;
                };

                fmt = inputs.treefmt-nix.lib.mkWrapper pkgs {
                    programs = {
                        nixfmt.enable = true;
                        nixfmt.indent = 4;
                        shfmt.enable = true;
                        shfmt.indent_size = 4;
                        shfmt.simplify = true;
                    };
                };

                deps = depsel pkgs;
            in
            {
                packages = {
                    legacyPackages = pkgs;

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
                };

                apps = {
                    nix = {
                        description = "the nix version that install(ed) this flake";
                        type = "app";
                        program = pkgs.lib.getExe pkgs.nix;
                    };
                };

                devShells = {
                    rust = pkgs.mkShell {
                        buildInputs = deps.dev ++ [
                            (pkgs.rust-bin.stable.latest.default.override {
                                extensions = [
                                    "rust-analyzer"
                                    "clippy"
                                ];
                            })
                        ];
                    };

                    rust-nightly = pkgs.mkShell {
                        buildInputs = deps.dev ++ [
                            (pkgs.rust-bin.nightly.latest.default.override {
                                extensions = [
                                    "rust-analyzer"
                                    "clippy"
                                ];
                            })
                        ];
                    };

                    default = pkgs.mkShell {
                        buildInputs = deps.dev;
                    };
                };

                formatter = fmt;

            }
        )
        // {
            nixosConfigurations = {
                deepthought = nixpkgs.lib.nixosSystem {
                    specialArgs = {
                        all-deps = pkgs: (depsel pkgs).all;
                        inherit inputs;
                    };
                    modules = [
                        nixos-hardware.nixosModules.lenovo-thinkpad-e495
                        ./os/hardware-configuration.nix
                        ./os/configuration.nix
                    ];
                };
            };
        };
}
