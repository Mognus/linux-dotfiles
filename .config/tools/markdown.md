# Markdown

Glow renders project documentation directly in the terminal.

## Usage

Read a specific file:

```sh
glow README.md
```

Open the interactive reader or browse Markdown files below the current directory:

```sh
glow --tui README.md
glow
```

## Desktop Integration

Markdown files opened through Thunar or `xdg-open` launch Glow in Alacritty.
The user MIME definition maps `.md` and `.markdown` files to `text/markdown`.
