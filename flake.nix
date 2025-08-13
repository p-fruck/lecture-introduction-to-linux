{
  description = "Dev shell to export slides";
  outputs = { self, nixpkgs }: {
    devShells.x86_64-linux.default =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in
      pkgs.mkShell {
        packages = [
          pkgs.just
          pkgs.pandoc
          pkgs.presenterm
          pkgs.typst
        ];
      };
  };
}
