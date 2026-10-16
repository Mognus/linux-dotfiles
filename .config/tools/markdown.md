# Markdown

Neovim renders project documentation in the terminal through `render-markdown.nvim`.

## Usage

Read a specific file:

```sh
nvim README.md
```

The plugin renders Markdown headings, lists and code blocks. The cursor line
stays raw for editing. Toggle rendering from Neovim's command line:

```vim
:RenderMarkdown toggle
```

## Desktop Integration

There is no Markdown-specific application mapping in `.config/mimeapps.list`.
Open files explicitly with Neovim, or use `Space+f+f` to find documentation in
the current repository. Glow is no longer part of the declared package lists.
