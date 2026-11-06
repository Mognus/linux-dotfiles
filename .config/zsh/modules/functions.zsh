# Plain theme files, no generator. Alacritty reloads colors.toml automatically.
dark() {
    cp "$HOME/.config/alacritty/themes/gruvbox-dark.toml" "$HOME/.config/alacritty/colors.toml" || return
    gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
}

light() {
    cp "$HOME/.config/alacritty/themes/gruvbox-light.toml" "$HOME/.config/alacritty/colors.toml" || return
    gsettings set org.gnome.desktop.interface gtk-theme Adwaita
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
}
