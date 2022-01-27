{
  inputs = {
    # This is the nixpkgs source we use we could use something like:
    # "nixos/nixpkgs/master" for the master branch
    # or "nixos/nixpkgs/nixos-21.11" for the current stable release (2021-11).
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixos-generators.url = "github:nix-community/nixos-generators";
    # make the generator use the same package version as the nixpkgs
    # version we defined earlier as an input.
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # Helper library for writing flakes
    flake-utils.url = "github:numtide/flake-utils";

  };
  outputs = { self, nixpkgs, flake-utils, nixos-generators, ... }:

    # This is a helper library that easily allows any type of
    # system to use this flake, it will generate for all the targets:
    # linux x86/arm, darwin x86/arm, etc.
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          # the syntax: `inherit mything;`
          # is just the equivalent of writing `mything = mything;`
          # in most cases
          inherit system;
          overlays = [ ];
        };

      in rec {

        packages = {
          # foo-vm is the package name
          foo-vm = nixos-generators.nixosGenerate {
            inherit pkgs;
            # Add any extra files you wish to use for configuration
            # NOTE: They must be added to git with `git add ./path/to/file`
            # otherwise the nix flake will not see them as it uses 
            # the git state to track source hashes
            modules = [ ./machines/foo/configuration.nix ];
            format = "vm";
          };

          # bar-vm is the package name
          bar-vm = nixos-generators.nixosGenerate {
            inherit pkgs;
            modules = [ ./machines/bar/configuration.nix ];

            format = "virtualbox";
          };
        };
      }

    );
}
