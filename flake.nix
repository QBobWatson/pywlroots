{
  description = "Hacking on qtile.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-2305.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, nixpkgs-2305 }:
    let
      pkgs2305 = nixpkgs-2305.legacyPackages.x86_64-linux;

      pkgs = import nixpkgs {
        localSystem = pkgs2305.system;
        # need 23.05 version of mesa
        overlays = [ (self: super: { mesa = pkgs2305.mesa; }) ];
      };

      lib = pkgs.lib;
    in {
      packages.x86_64-linux.default =
        let
          inherit (pkgs) pkg-config libinput libxkbcommon pixman
            xorg udev wayland wlroots python310;
          inherit (pkgs.python310Packages) cffi pywayland xkbcommon pytestCheckHook;
        in pkgs.python310Packages.buildPythonPackage rec {
          pname = "pywlroots";
          version = "0.16.6";
          format = "setuptools";
          src = ./.;

          nativeBuildInputs = [ pkg-config ];
          propagatedNativeBuildInputs = [ cffi ];
          buildInputs = [ libinput libxkbcommon pixman xorg.libxcb xorg.xcbutilwm udev wayland wlroots ];
          propagatedBuildInputs = [ cffi pywayland xkbcommon ];

          postBuild = ''
            ${python310.pythonForBuild.interpreter} wlroots/ffi_build.py
          '';

          pythonImportsCheck = [ "wlroots" ];
          nativeCheckInputs = [ pytestCheckHook ];
        };
    };
}
