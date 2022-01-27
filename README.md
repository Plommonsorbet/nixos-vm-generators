# Generate Nixos VM Images

## Getting Started

The main starting point is the `flake.nix` file, this is where all the
input sources are defined as well as the packages. In this case the
"VMs" that are generated are seen as packages by nix.


There's two packages vms defined in there:

- `foo-vm` (generates a runnable qemu image and bootscript)
- `bar-vm` (generates a vbox image)


They have their respective configuration in	`./machines/<foo/bar>/configuration.nix`,
this is not a magic path or anything, just one that is defined in `flake.nix`


### Build images

**Generate foo vm:**
```sh
$ nix build .#foo-vm
```

This will output an executable script here: `./result/bin/run-nixos-vm` that you can run to start your vm.


**Generate bar vm:**

```sh
$ nix build .#bar-vm
```

This will output a vbox image here: `./result/nixos-*.ova`


##### About the nix build command

The `nix build` and any `flake` enabled commands in general use the
following syntax to specify what to build:

```sh
nix build <path to directory with flake>#<package name>
```

_However the previous commands relies on you being in the git root dir, in which case it becomes_ `.`

