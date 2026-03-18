local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font("MesloLGS NF")
config.font_size = 12.0

config.background = {
  {
    source = { Color = 'rgba(30, 30, 46, 1)' },
    width = '100%',
    height = '100%',
  },
  {
    source = { File = wezterm.home_dir .. "/Images/Wallpaper/Ghost-in-the-shell-WP.jpg" },
    opacity = 0.2,
    width = "100%",
    height = "100%",
  }
}

config.enable_tab_bar = false

config.color_scheme = 'Catppuccin Mocha'

return config
