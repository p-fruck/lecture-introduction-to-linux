{
  description = "Dev shell to export slides";
  outputs = { self, nixpkgs }: {
    devShells.x86_64-linux.default =
      let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          weasyprint
        ]);
      in
      pkgs.mkShell {
        packages = [
          pkgs.inconsolata
          pkgs.just
          pkgs.pandoc
          pkgs.presenterm
          pkgs.typst
          pkgs.prek
          pythonEnv
        ];
      };
  };
}
