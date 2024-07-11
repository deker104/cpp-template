{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin-vsc = {
      url = "https://flakehub.com/f/catppuccin/vscode/3.14.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };
  outputs = { self, nixpkgs, catppuccin-vsc, ... }: 
  let
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    forAllSystems = fn: nixpkgs.lib.genAttrs systems (system: fn (import nixpkgs {
      inherit system;
      overlays = [ catppuccin-vsc.overlays.default ];
    }));
  in
  {
    devShells = forAllSystems (pkgs: {
      default = import ./devshell.nix { inherit pkgs; };
    });
  };
}
