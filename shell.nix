let
  nixpkgs = (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/945ec499041db73043f745fad3b2a3a01e826081.tar.gz";
    sha256 = "sha256:1ixv310sjw0r5vda4yfwp3snyha2i9h7aqygd43cyvdk2qsjk8pq";
  });
in
{ pkgs ? import nixpkgs { } }:

with pkgs;
let nixBin =
  writeShellScriptBin "nix" ''
    ${nix}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in
mkShell {
  buildInputs = [
    git
    nix-zsh-completions
    git-crypt
    (nixos { nix.package = nixFlakes; }).nixos-rebuild
  ];
  shellHook = ''
    export FLAKE="$(pwd)"
    export PATH="$FLAKE/bin:${nixBin}/bin:$PATH"
  '';
}
