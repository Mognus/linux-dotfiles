{
  lib,
  rustPlatform,
  makeWrapper,
  runtimeShell,
  dconf,
  libnotify,
  tmux,
}:
rustPlatform.buildRustPackage {
  pname = "appearancectl";
  version = "0.1.0";

  # Keep the repository layout: integration tests also read the theme palettes.
  # Local build output and unrelated dotfiles are not part of the Nix source.
  src = lib.fileset.toSource {
    root = ../..;
    fileset = lib.fileset.unions [
      ../../tools/appearancectl/Cargo.toml
      ../../tools/appearancectl/Cargo.lock
      ../../tools/appearancectl/src
      ../../tools/appearancectl/tests
      ../../.config/themes/palettes
    ];
  };
  sourceRoot = "source/tools/appearancectl";
  cargoLock.lockFile = ../../tools/appearancectl/Cargo.lock;

  nativeBuildInputs = [ makeWrapper ];

  # The test helpers must also work without /bin/sh in the Nix sandbox.
  postPatch = ''
    substituteInPlace tests/config.rs \
      --replace-fail '#!/bin/sh' '#!${runtimeShell}'
  '';

  # Hyprland/Quickshell need not provide these commands in their own PATH.
  postInstall = ''
    wrapProgram "$out/bin/appearancectl" \
      --prefix PATH : ${
        lib.makeBinPath [
          dconf
          libnotify
          tmux
        ]
      }
  '';
}
