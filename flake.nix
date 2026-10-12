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
        fontsConf = pkgs.makeFontsConf {
          fontDirectories = [
            pkgs.inconsolata
            pkgs.dejavu_fonts
            pkgs.nerd-fonts.symbols-only
          ];
        };
      in
      pkgs.mkShell {
        FONTCONFIG_FILE = fontsConf;
        packages = [
          pkgs.gcc
          pkgs.inconsolata
          pkgs.dejavu_fonts
          pkgs.just
          pkgs.pandoc
          pkgs.prek
          pkgs.presenterm
          pkgs.typst
          pkgs.yq
          pythonEnv
        ];
      };
  };
}
