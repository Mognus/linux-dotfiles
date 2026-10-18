use std::env;
use std::fs::{self, File, OpenOptions};
use std::io::Write;
use std::path::PathBuf;

use anyhow::{Context, Result};
use tempfile::NamedTempFile;

pub struct Paths {
    pub state_dir: PathBuf,
    pub palette_dir: PathBuf,
}

impl Paths {
    pub fn from_home() -> Result<Self> {
        let home = PathBuf::from(env::var_os("HOME").context("HOME is not set")?);
        Ok(Self {
            state_dir: home.join(".local/state/dotfiles-theme"),
            palette_dir: home.join(".config/themes/palettes"),
        })
    }

    /// Hold this file open until all writes are done, including a full theme change.
    pub fn lock(&self) -> Result<File> {
        fs::create_dir_all(&self.state_dir).context("create theme state directory")?;
        // Keep the existing lock name: the TOML itself is replaced by rename.
        let lock = OpenOptions::new()
            .create(true)
            .truncate(false)
            .read(true)
            .write(true)
            .open(self.state_dir.join("alacritty.lock"))
            .context("open appearance lock")?;
        lock.lock().context("lock appearance state")?;
        Ok(lock)
    }

    /// Replace one state file without exposing partially written content to readers.
    pub fn write_state(&self, filename: &str, contents: &str) -> Result<()> {
        let path = self.state_dir.join(filename);
        let mut temporary = NamedTempFile::new_in(&self.state_dir)
            .with_context(|| format!("create temporary file for {}", path.display()))?;
        temporary.write_all(contents.as_bytes())?;
        temporary.as_file().sync_all()?;
        temporary
            .persist(&path)
            .with_context(|| format!("replace {}", path.display()))?;
        File::open(&self.state_dir)?.sync_all()?;
        Ok(())
    }
}
