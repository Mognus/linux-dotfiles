use std::process::Command;

use anyhow::{Context, Result, ensure};

use crate::palette::{Mode, Palette};
use crate::paths::Paths;

pub fn write_colors(paths: &Paths, palette: &Palette) -> Result<()> {
    let background = &palette.background;
    let foreground = &palette.foreground;
    let surface = &palette.surface;
    let accent = &palette.accent;

    let css = format!(
        "@define-color theme_bg_color {background};\n\
         @define-color theme_fg_color {foreground};\n\
         @define-color theme_base_color {surface};\n\
         @define-color theme_text_color {foreground};\n\
         @define-color theme_selected_bg_color {accent};\n\
         @define-color theme_selected_fg_color {background};\n\
         @define-color accent_bg_color {accent};\n\
         @define-color accent_color {accent};\n\
         @define-color accent_fg_color {background};\n\
         @define-color window_bg_color {background};\n\
         @define-color window_fg_color {foreground};\n"
    );
    paths.write_state("gtk.css", &css)
}

pub fn apply_preferences(palette: &Palette) -> Result<()> {
    let (gtk_theme, color_scheme) = match palette.mode {
        Mode::Light => ("Adwaita", "prefer-light"),
        Mode::Dark => ("Adwaita-dark", "prefer-dark"),
    };
    write_preference("gtk-theme", gtk_theme)?;
    write_preference("color-scheme", color_scheme)?;
    Ok(())
}

fn write_preference(key: &str, value: &str) -> Result<()> {
    let path = format!("/org/gnome/desktop/interface/{key}");
    let output = Command::new("dconf")
        .args(["write", &path, &format!("'{value}'")])
        .output()
        .with_context(|| format!("run dconf for {key}"))?;
    ensure!(
        output.status.success(),
        "dconf write {key} failed: {}",
        String::from_utf8_lossy(&output.stderr).trim()
    );
    Ok(())
}
