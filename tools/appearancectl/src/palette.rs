use std::collections::BTreeMap;
use std::fs;
use std::path::Path;

use anyhow::{Context, Result, ensure};
use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Deserialize, Serialize)]
#[serde(rename_all = "lowercase")]
pub enum Mode {
    Light,
    Dark,
}

#[derive(Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Palette {
    pub name: String,
    pub mode: Mode,
    pub background: String,
    pub surface: String,
    pub foreground: String,
    pub foreground_soft: String,
    pub accent: String,
    pub secondary: String,
    pub success: String,
    pub danger: String,
    pub warning: String,
    pub violet: String,
    pub muted: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub terminal_background: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub terminal_foreground: Option<String>,
    // Preserve the remaining shell colors when generating colors.json.
    #[serde(flatten)]
    pub shell_colors: BTreeMap<String, Value>,
}

impl Palette {
    pub fn read(path: &Path) -> Result<Self> {
        let contents =
            fs::read_to_string(path).with_context(|| format!("read palette {}", path.display()))?;
        let palette: Self = serde_json::from_str(&contents).context("parse palette")?;
        palette.validate()?;
        Ok(palette)
    }

    fn validate(&self) -> Result<()> {
        for color in [
            &self.background,
            &self.surface,
            &self.foreground,
            &self.foreground_soft,
            &self.accent,
            &self.secondary,
            &self.success,
            &self.danger,
            &self.warning,
            &self.violet,
            &self.muted,
        ] {
            validate_color(color)?;
        }
        if let Some(color) = &self.terminal_background {
            validate_color(color)?;
        }
        if let Some(color) = &self.terminal_foreground {
            validate_color(color)?;
        }
        Ok(())
    }
}

fn validate_color(color: &str) -> Result<()> {
    ensure!(
        color.len() == 7
            && color.starts_with('#')
            && color.as_bytes()[1..].iter().all(u8::is_ascii_hexdigit),
        "palette colors must be #RRGGBB, got {color}"
    );
    Ok(())
}
