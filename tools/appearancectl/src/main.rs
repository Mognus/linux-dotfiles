use std::env;
use std::fs::{self, File, OpenOptions};
use std::io::Write;
use std::path::{Path, PathBuf};

use anyhow::{Context, Result, bail, ensure};
use serde::{Deserialize, Serialize};
use tempfile::NamedTempFile;
use toml_edit::{DocumentMut, Item, value};

const USAGE: &str = "usage: appearancectl init | get | theme <palette.json> | terminal <opacity|font-size|padding> <value> | terminal reset";

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
struct Palette {
    background: String,
    foreground_soft: String,
    accent: String,
    terminal_background: Option<String>,
    terminal_foreground: Option<String>,
}

#[derive(Serialize)]
struct TerminalSettings {
    opacity: f64,
    font_size: f64,
    padding: i64,
}

enum Change {
    Init,
    Theme(Palette),
    Opacity(f64),
    FontSize(f64),
    Padding(i64),
    Reset,
}

fn main() {
    if let Err(error) = run() {
        eprintln!("appearancectl: {error:#}");
        std::process::exit(1);
    }
}

fn run() -> Result<()> {
    let args: Vec<String> = env::args().skip(1).collect();
    let state_dir = state_dir()?;
    if args.as_slice() == ["get"] {
        let document = read_document(&state_dir.join("alacritty.toml"))?;
        println!("{}", serde_json::to_string(&settings(&document)?)?);
        return Ok(());
    }

    let change = parse_change(&args)?;
    fs::create_dir_all(&state_dir).context("create theme state directory")?;
    // Lock a stable, separate file: the TOML itself is replaced by rename.
    let lock = OpenOptions::new()
        .create(true)
        .truncate(false)
        .read(true)
        .write(true)
        .open(state_dir.join("alacritty.lock"))
        .context("open configuration lock")?;
    lock.lock().context("lock Alacritty configuration")?;

    let path = state_dir.join("alacritty.toml");
    let mut document = read_document(&path)?;
    ensure_defaults(&mut document);
    match change {
        Change::Init => {}
        Change::Theme(palette) => apply_palette(&mut document, &palette),
        Change::Opacity(opacity) => document["window"]["opacity"] = value(opacity),
        Change::FontSize(size) => document["font"]["size"] = value(size),
        Change::Padding(padding) => set_padding(&mut document, padding),
        Change::Reset => {
            document["window"]["opacity"] = value(0.93);
            document["font"]["size"] = value(20.0);
            set_padding(&mut document, 12);
        }
    }
    let current = settings(&document)?;
    atomic_write(&path, &document.to_string())?;
    println!("{}", serde_json::to_string(&current)?);
    Ok(())
}

fn state_dir() -> Result<PathBuf> {
    if let Some(path) = env::var_os("THEME_STATE_DIR") {
        return Ok(PathBuf::from(path));
    }
    let root = match env::var_os("XDG_STATE_HOME") {
        Some(path) => PathBuf::from(path),
        None => PathBuf::from(env::var_os("HOME").context("HOME is not set")?).join(".local/state"),
    };
    Ok(root.join("dotfiles-theme"))
}

fn parse_change(args: &[String]) -> Result<Change> {
    match args {
        [command] if command == "init" => Ok(Change::Init),
        [command, path] if command == "theme" => {
            let contents = fs::read_to_string(path).context("read palette")?;
            let palette: Palette = serde_json::from_str(&contents).context("parse palette")?;
            for color in [
                Some(&palette.background),
                Some(&palette.foreground_soft),
                Some(&palette.accent),
                palette.terminal_background.as_ref(),
                palette.terminal_foreground.as_ref(),
            ]
            .into_iter()
            .flatten()
            {
                ensure!(
                    color.len() == 7
                        && color.starts_with('#')
                        && color.as_bytes()[1..].iter().all(u8::is_ascii_hexdigit),
                    "palette colors must be #RRGGBB, got {color}"
                );
            }
            Ok(Change::Theme(palette))
        }
        [command, setting] if command == "terminal" && setting == "reset" => Ok(Change::Reset),
        [command, setting, input] if command == "terminal" => match setting.as_str() {
            "opacity" => Ok(Change::Opacity(number_in_range(input, 0.0, 1.0)?)),
            "font-size" => Ok(Change::FontSize(number_in_range(input, 6.0, 48.0)?)),
            "padding" => {
                let padding: i64 = input.parse().context("padding must be an integer")?;
                ensure!(
                    (0..=48).contains(&padding),
                    "padding must be between 0 and 48"
                );
                Ok(Change::Padding(padding))
            }
            _ => bail!("{USAGE}"),
        },
        _ => bail!("{USAGE}"),
    }
}

fn number_in_range(input: &str, minimum: f64, maximum: f64) -> Result<f64> {
    let number: f64 = input.parse().context("expected a number")?;
    ensure!(
        number.is_finite() && (minimum..=maximum).contains(&number),
        "value must be between {minimum} and {maximum}"
    );
    Ok(number)
}

fn read_document(path: &Path) -> Result<DocumentMut> {
    match fs::read_to_string(path) {
        Ok(contents) => contents.parse().context("parse existing Alacritty TOML"),
        Err(error) if error.kind() == std::io::ErrorKind::NotFound => Ok(DocumentMut::new()),
        Err(error) => Err(error).context("read Alacritty configuration"),
    }
}

fn ensure_defaults(document: &mut DocumentMut) {
    if item_at(document, &["window", "opacity"]).is_none() {
        document["window"]["opacity"] = value(0.93);
    }
    if item_at(document, &["font", "size"]).is_none() {
        document["font"]["size"] = value(20.0);
    }
    for axis in ["x", "y"] {
        if item_at(document, &["window", "padding", axis]).is_none() {
            document["window"]["padding"][axis] = value(12);
        }
    }
}

fn set_padding(document: &mut DocumentMut, padding: i64) {
    document["window"]["padding"]["x"] = value(padding);
    document["window"]["padding"]["y"] = value(padding);
}

fn apply_palette(document: &mut DocumentMut, palette: &Palette) {
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
        opacity: number(item_at(document, &["window", "opacity"]), 0.93)?,
        font_size: number(item_at(document, &["font", "size"]), 20.0)?,
        padding: match item_at(document, &["window", "padding", "x"]) {
            None => 12,
            Some(item) => item.as_integer().context("padding must be an integer")?,
        },
    })
}

fn atomic_write(path: &Path, contents: &str) -> Result<()> {
    let directory = path.parent().context("configuration path has no parent")?;
    let mut temporary =
        NamedTempFile::new_in(directory).context("create temporary configuration")?;
    temporary
        .write_all(contents.as_bytes())
        .context("write configuration")?;
    temporary
        .as_file()
        .sync_all()
        .context("sync configuration")?;
    temporary.persist(path).context("replace configuration")?;
    File::open(directory)?
        .sync_all()
        .context("sync configuration directory")?;
    Ok(())
}
