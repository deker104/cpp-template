{ pkgs, ... }:
let
  llvm = pkgs.llvmPackages_18;
  theme = pkgs.catppuccin-vsc.override {
    accent = "sapphire";
    boldKeywords = true;
    italicComments = false;
    italicKeywords = false;
    extraBordersEnabled = false;
    workbenchMode = "default";
    bracketMode = "rainbow";
  };
  code = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscodium;
    vscodeExtensions = with pkgs.vscode-extensions; [
      mesonbuild.mesonbuild
      vadimcn.vscode-lldb
      llvm-vs-code-extensions.vscode-clangd
      theme
      catppuccin.catppuccin-vsc-icons
      jnoortheen.nix-ide
    ];
  };
in
pkgs.mkShell.override { stdenv = llvm.stdenv; } {
  packages = with pkgs; [
    bashInteractive
    llvm.clang-tools
    meson
    ninja
    code
  ];
  hardeningDisable = [ "all" ];
  shellHook = ''
    exec ${pkgs.lib.getExe code} .
  '';
}
