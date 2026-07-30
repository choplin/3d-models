{
  description = "Parametric OpenSCAD models for 3D printing";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux"];
    forAllSystems = f:
      nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
  in {
    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        packages =
          [pkgs.jq]
          # OpenSCAD is provisioned on Linux only. On macOS it comes from the
          # desktop app instead (brew install --cask openscad): the workflow needs
          # that app's live preview, and the one install already puts the very
          # same binary on PATH as the CLI. Adding a second OpenSCAD here would
          # leave the GUI being watched and the CLI being driven on different
          # versions.
          #
          # openscad-unstable, not openscad: the latter is still the 2021.01
          # release, which predates the --summary / --summary-file flags that
          # build.sh parses its geometry report out of.
          ++ pkgs.lib.optional pkgs.stdenv.isLinux pkgs.openscad-unstable;

        shellHook = ''
          echo "3d-models: openscad $(command -v openscad >/dev/null && openscad --version 2>&1 | head -1 || echo 'NOT ON PATH')"
        '';
      };
    });
  };
}
