use std::fs;

use anyhow::{Context, Result};
use serde::Serialize;
use toml_edit::{DocumentMut, Item, value};

use crate::palette::Palette;
use crate::paths::Paths;

const DEFAULT_OPACITY: f64 = 0.93;
const DEFAULT_FONT_SIZE: f64 = 20.0;
const DEFAULT_PADDING: i64 = 12;

#[derive(Serialize)]
pub struct TerminalSettings {
    pub opacity: f64,
    pub font_size: f64,
    pub padding: i64,
}

pub enum TerminalChange {
    Init,
    Opacity(f64),
    FontSize(f64),
    Padding(i64),
    Reset,
}

pub fn read_settings(paths: &Paths) -> Result<TerminalSettings> {
    let document = read_document(paths)?;
    settings(&document)
}

/// The caller holds the shared appearance lock throughout this update.
pub fn update_terminal(paths: &Paths, change: TerminalChange) -> Result<TerminalSettings> {
    let mut document = read_document(paths)?;
    ensure_defaults(&mut document);
    match change {
        TerminalChange::Init => {}
        TerminalChange::Opacity(opacity) => document["window"]["opacity"] = value(opacity),
        TerminalChange::FontSize(size) => document["font"]["size"] = value(size),
        TerminalChange::Padding(padding) => set_padding(&mut document, padding),
        TerminalChange::Reset => {
            document["window"]["opacity"] = value(DEFAULT_OPACITY);
            document["font"]["size"] = value(DEFAULT_FONT_SIZE);
            set_padding(&mut document, DEFAULT_PADDING);
        }
    }
    save_document(paths, &document)
}

/// Replace only colors; preserve terminal adjustments, comments and unknown fields.
pub fn apply_palette(paths: &Paths, palette: &Palette) -> Result<TerminalSettings> {
    let mut document = read_document(paths)?;
    ensure_defaults(&mut document);

    let background = palette
        .terminal_background
        .as_ref()
        .unwrap_or(&palette.background);
    let foreground = palette
        .terminal_foreground
        .as_ref()
        .unwrap_or(&palette.foreground_soft);
    document["colors"]["primary"]["background"] = value(background);
    document["colors"]["primary"]["foreground"] = value(foreground);
    document["colors"]["cursor"]["cursor"] = value(&palette.accent);
    document["colors"]["cursor"]["text"] = value(background);
    document["colors"]["selection"]["background"] = value(&palette.accent);
    document["colors"]["selection"]["text"] = value(foreground);

    save_document(paths, &document)
}

fn read_document(paths: &Paths) -> Result<DocumentMut> {
    match fs::read_to_string(paths.state_dir.join("alacritty.toml")) {
        Ok(contents) => contents.parse().context("parse existing Alacritty TOML"),
        Err(error) if error.kind() == std::io::ErrorKind::NotFound => Ok(DocumentMut::new()),
        Err(error) => Err(error).context("read Alacritty configuration"),
    }
}

fn save_document(paths: &Paths, document: &DocumentMut) -> Result<TerminalSettings> {
    let current = settings(document)?;
    paths.write_state("alacritty.toml", &document.to_string())?;
    Ok(current)
}

fn ensure_defaults(document: &mut DocumentMut) {
    if item_at(document, &["window", "opacity"]).is_none() {
        document["window"]["opacity"] = value(DEFAULT_OPACITY);
    }
    if item_at(document, &["font", "size"]).is_none() {
        document["font"]["size"] = value(DEFAULT_FONT_SIZE);
    }
    for axis in ["x", "y"] {
        if item_at(document, &["window", "padding", axis]).is_none() {
            document["window"]["padding"][axis] = value(DEFAULT_PADDING);
        }
    }
}

fn set_padding(document: &mut DocumentMut, padding: i64) {
    document["window"]["padding"]["x"] = value(padding);
    document["window"]["padding"]["y"] = value(padding);
}

fn item_at<'a>(document: &'a DocumentMut, path: &[&str]) -> Option<&'a Item> {
    let mut item = document.as_item();
    for key in path {
        item = item.get(key)?;
    }
    Some(item)
}

fn number(item: Option<&Item>, fallback: f64) -> Result<f64> {
    let Some(item) = item else {
        return Ok(fallback);
    };
    item.as_float()
        .or_else(|| item.as_integer().map(|value| value as f64))
        .context("expected a numeric terminal setting")
}

fn settings(document: &DocumentMut) -> Result<TerminalSettings> {
    Ok(TerminalSettings {
        opacity: number(item_at(document, &["window", "opacity"]), DEFAULT_OPACITY)?,
        font_size: number(item_at(document, &["font", "size"]), DEFAULT_FONT_SIZE)?,
        padding: match item_at(document, &["window", "padding", "x"]) {
            None => DEFAULT_PADDING,
            Some(item) => item.as_integer().context("padding must be an integer")?,
        },
    })
}
