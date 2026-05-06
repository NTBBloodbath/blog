{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # norgolith.url = "github:NTBBloodbath/norgolith?shallow=1";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    # norgolith,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs {inherit system;};
      in
      {
        # nix develop
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustywind # Organize Tailwind CSS classes
            watchman # required by tailwindcss CLI for watch functionality
            tailwindcss_4
            tailwindcss-language-server
            mprocs # Run multiple commands in parallel
            norgolith
            # norgolith.packages.${system}.default
          ];
        };
      });
}
