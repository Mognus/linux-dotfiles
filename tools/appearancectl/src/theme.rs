use std::fs;
use std::path::Path;
use std::process::{Command, Stdio};

use anyhow::{Context, Result, ensure};

use crate::alacritty::{self, TerminalSettings};
use crate::gtk;
use crate::palette::Palette;
use crate::paths::Paths;
use crate::terminal;

/// Apply a user-selected palette and announce it, as the old theme switcher did.
pub fn apply(paths: &Paths, palette_path: &Path) -> Result<TerminalSettings> {
    let palette = Palette::read(palette_path)?;
    let settings = apply_palette(paths, palette_path, &palette)?;
    terminal::refresh_tmux_colors();
    notify_theme_changed(&palette);
    Ok(settings)
}

/// Restore the saved theme at login; a fresh setup starts with Retro Dark.
pub fn restore(paths: &Paths) -> Result<TerminalSettings> {
    let theme_name = match fs::read_to_string(paths.state_dir.join("current")) {
        Ok(contents) => contents.trim().to_owned(),
        Err(error) if error.kind() == std::io::ErrorKind::NotFound => "retro-dark".to_owned(),
        Err(error) => return Err(error).context("read saved theme"),
    };
    validate_theme_name(&theme_name)?;
    let palette_path = paths.palette_dir.join(format!("{theme_name}.json"));
    let palette = Palette::read(&palette_path)?;
    let settings = apply_palette(paths, &palette_path, &palette)?;
    terminal::refresh_tmux_colors();
    Ok(settings)
}

fn apply_palette(
    paths: &Paths,
    palette_path: &Path,
    palette: &Palette,
) -> Result<TerminalSettings> {
    let theme_name = palette_path
        .file_stem()
        .and_then(|name| name.to_str())
        .context("palette filename must have a UTF-8 theme name")?;
    validate_theme_name(theme_name)?;

    // One lock covers the complete change, including concurrent terminal sliders.
    // Each file is replaced atomically; the set of files is not one transaction.
    let _lock = paths.lock()?;
    let settings = alacritty::apply_palette(paths, palette)?;
    write_quickshell_colors(paths, palette)?;
    gtk::write_colors(paths, palette)?;
    gtk::apply_preferences(palette)?;
    paths.write_state("current", &format!("{theme_name}\n"))?;
    Ok(settings)
}

fn write_quickshell_colors(paths: &Paths, palette: &Palette) -> Result<()> {
    let colors = serde_json::to_string_pretty(palette).context("serialize shell palette")?;
    paths.write_state("colors.json", &format!("{colors}\n"))
}

fn validate_theme_name(name: &str) -> Result<()> {
    ensure!(
        !name.is_empty()
            && name
                .bytes()
                .all(|byte| byte.is_ascii_alphanumeric() || byte == b'-' || byte == b'_'),
        "theme name must contain only letters, digits, hyphens or underscores"
    );
    Ok(())
}

fn notify_theme_changed(palette: &Palette) {
    // Notifications are optional: a missing daemon must not fail a theme change.
    let _ = Command::new("notify-send")
        .args(["-t", "1200", "Theme", &palette.name])
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status();
}
