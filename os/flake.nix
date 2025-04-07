{

  # TODO:
  # - Automatic Updates
  # - stable or unstable?
  # - how to install my favorite packages systemwide?

  description = "My OS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    { self, nixpkgs, nixos-hardware }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        deepthought = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
          };
          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-e495
            ./hardware-configuration.nix
            ./configuration.nix
          ];
        };
      };
    };
}
