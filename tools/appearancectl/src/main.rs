mod alacritty;
mod ansi_colors;
mod gtk;
mod palette;
mod paths;
mod terminal;
mod theme;

use std::env;
use std::path::PathBuf;

use anyhow::{Context, Result, bail, ensure};

use alacritty::{TerminalChange, TerminalSettings};
use paths::Paths;

const USAGE: &str = "usage: appearancectl init | get | restore | theme <palette.json> | terminal <opacity|font-size|padding> <value> | terminal reset";

enum Command {
    Init,
    Get,
    Restore,
    Theme(PathBuf),
    Terminal(TerminalChange),
}

fn main() {
    if let Err(error) = run() {
        eprintln!("appearancectl: {error:#}");
        std::process::exit(1);
    }
}

fn run() -> Result<()> {
    let arguments: Vec<String> = env::args().skip(1).collect();
    let command = parse_command(&arguments)?;
    let paths = Paths::from_home()?;

    let settings = match command {
        Command::Get => alacritty::read_settings(&paths)?,
        Command::Init => {
            let _lock = paths.lock()?;
            alacritty::update_terminal(&paths, TerminalChange::Init)?
        }
        Command::Terminal(change) => {
            let _lock = paths.lock()?;
            alacritty::update_terminal(&paths, change)?
        }
        Command::Theme(palette_path) => theme::apply(&paths, &palette_path)?,
        Command::Restore => theme::restore(&paths)?,
    };

    print_settings(&settings)
}

fn print_settings(settings: &TerminalSettings) -> Result<()> {
    println!("{}", serde_json::to_string(settings)?);
    Ok(())
}

fn parse_command(arguments: &[String]) -> Result<Command> {
    match arguments {
        [command] if command == "init" => Ok(Command::Init),
        [command] if command == "get" => Ok(Command::Get),
        [command] if command == "restore" => Ok(Command::Restore),
        [command, path] if command == "theme" => Ok(Command::Theme(PathBuf::from(path))),
        [command, setting] if command == "terminal" && setting == "reset" => {
            Ok(Command::Terminal(TerminalChange::Reset))
        }
        [command, setting, input] if command == "terminal" => {
            let change = parse_terminal_change(setting, input)?;
            Ok(Command::Terminal(change))
        }
        _ => bail!("{USAGE}"),
    }
}

fn parse_terminal_change(setting: &str, input: &str) -> Result<TerminalChange> {
    match setting {
        "opacity" => Ok(TerminalChange::Opacity(number_in_range(input, 0.0, 1.0)?)),
        "font-size" => Ok(TerminalChange::FontSize(number_in_range(input, 6.0, 48.0)?)),
        "padding" => {
            let padding: i64 = input.parse().context("padding must be an integer")?;
            ensure!(
                (0..=48).contains(&padding),
                "padding must be between 0 and 48"
            );
            Ok(TerminalChange::Padding(padding))
        }
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
