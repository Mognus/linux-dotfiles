# General programs, grouped like the Arch packages.txt they replace.
# Tools a linked config depends on stay in magnus.nix next to that config.
{ pkgs, ... }:
{
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
    chromium
    thunderbird
    tor-browser
    libreoffice
    papers
    loupe
    discord
    obsidian
    gimp

    # --- Dev Languages ---
    # rustup ships the rust-analyzer proxy: rustup component add rust-analyzer
    rustup
    go
    gopls
    nodejs
    pnpm
    typescript
    typescript-language-server
    python3
    pipx
    ruff
    pyright
    buf
    gnumake
    ansible
    typst

    # --- AI Agents ---
    claude-code
    codex

    # --- Containers ---
    podman-compose

    # --- File Manager ---
    ffmpegthumbnailer

    # --- Media ---
    yt-dlp
    mpv

    # --- Tools ---
    pass
    curl
    glow
    btop
    gh
    fastfetch
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
    openvpn
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
