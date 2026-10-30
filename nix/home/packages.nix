# General programs, grouped by purpose.
# Tools a linked config depends on stay in magnus.nix next to that config.
{ pkgs, ... }:
{
  # rust-analyzer needs the standard library sources for completion and navigation.
  home.sessionVariables.RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

  home.packages = with pkgs; [
    # --- Editor ---
    zed-editor

    # --- Wayland Tools ---
    socat
    imagemagick
    xdg-user-dirs

    # --- Audio ---
    alsa-utils

    # --- Apps ---
    # firefox comes from programs.firefox in magnus.nix
    # A plain package on purpose: programs.librewolf writes its profiles to
    # ~/.librewolf, and LibreWolf then uses that instead of ~/.config/librewolf.
    librewolf
    chromium
    thunderbird
    tor-browser
    libreoffice
    papers
    foliate
    loupe
    discord
    simplex-chat-desktop
    obsidian
    gimp

    # --- Dev Languages ---
    # Rust straight from nixpkgs; a project that pins its own version gets a devShell.
    cargo
    rustc
    rust-analyzer
    clippy
    rustfmt
    go
    gopls
    nodejs
    pnpm
    typescript
    vtsls
    python3
    pipx
    ruff
    pyright
    buf
    gnumake
    ansible
    typst

    # --- Formatters (Conform in .config/nvim/lua/core/format.lua) ---
    # ruff, rustfmt and gofmt come from the language packages above;
    # qmlformat comes with qt6.qtdeclarative below.
    stylua
    nixfmt
    prettier
    shfmt

    # --- Language Servers (configs in .config/nvim/lsp/) ---
    nixd
    lua-language-server
    lemminx
    # jsonls, cssls, html
    vscode-langservers-extracted
    bash-language-server
    tinymist
    yaml-language-server
    ansible-language-server
    # ansiblels runs it for validation
    ansible-lint
    svelte-language-server
    # dockerls; Compose files go through yamlls
    dockerfile-language-server
    # qmlls (Quickshell config)
    qt6.qtdeclarative

    # --- AI Agents ---
    claude-code
    codex
    opencode
    bubblewrap

    # --- Containers ---
    podman-compose

    # --- File Manager ---
    ffmpegthumbnailer

    # --- Media ---
    yt-dlp
    mpv

    # --- Tools ---
    btop
    pass
    curl
    gh
    unzip
    _7zz
    rsync
    qrencode
    termdown

    # --- Security / Network Tools ---
    nmap
    gobuster
    hashcat
    john
    dnsutils

    # --- TeX ---
    (texliveBasic.withPackages (
      ps: with ps; [
        collection-langgerman
        collection-langeuropean
        collection-latexextra
        collection-latexrecommended
      ]
    ))
  ];
}
