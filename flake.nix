{
  description = "Ally Contact Networking Application - Fork of VeilidChat";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://pre-commit-hooks.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:ethnh/nixpkgs";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts = {
      url = "flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    fenix.url = "github:nix-community/fenix/monthly";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = inputs@{ flake-parts, nixpkgs, pre-commit-hooks, fenix, ... }: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    perSystem = { system, ... }:
      let

        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            fenix.overlays.default
          ];
          config = {
            android_sdk.accept_license = true;
            allowUnfree = true;
          };
        };

        shell = import ./shell.nix { inherit pkgs pre-commit-hooks fenix system; };
      in
      {
        checks = {
          inherit shell;
        };

        devShells.default = shell;
      };
  };
}
