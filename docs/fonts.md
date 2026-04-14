# Fonts

## Installation

**User-only** (no sudo, recommended):
```bash
mkdir -p ~/.local/share/fonts
cp *.ttf ~/.local/share/fonts/
fc-cache -fv
```

**System-wide:**
```bash
sudo cp *.ttf /usr/share/fonts/
fc-cache -fv
```

## Google Fonts (single font)

```bash
curl -o /tmp/font.zip "https://fonts.google.com/download?family=Syne"
unzip /tmp/font.zip -d ~/.local/share/fonts/Syne
fc-cache -fv
```

Or download manually from fonts.google.com and move the TTFs to `~/.local/share/fonts/`.

## Useful commands

```bash
fc-list | grep -i "fontname"   # check if font is installed
fc-cache -fv                   # rebuild font cache
```
