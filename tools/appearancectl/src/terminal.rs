use std::fs::{File, OpenOptions};
use std::io::Write;
use std::os::unix::fs::OpenOptionsExt;
use std::process::Command;
use std::thread;
use std::time::Duration;

// OSC 10/11 ask for the terminal's current foreground/background. The replies
// go to tmux, which updates its cached colors and notifies interested programs.
const COLOR_QUERY: &[u8] = b"\x1b]10;?\x07\x1b]11;?\x07";

pub fn refresh_tmux_colors() {
    let mut terminals = attached_tmux_terminals();
    if terminals.is_empty() {
        return;
    }

    // Alacritty reloads its TOML asynchronously. Ask after 250 ms and again
    // after 1 second; query real colors instead of guessing when reload finished.
    for delay_ms in [250, 750] {
        thread::sleep(Duration::from_millis(delay_ms));
        for terminal in &mut terminals {
            if let Err(error) = terminal.write_all(COLOR_QUERY) {
                eprintln!("appearancectl: could not refresh terminal colors: {error}");
            }
        }
    }
}

fn attached_tmux_terminals() -> Vec<File> {
    // tmux is optional. No executable, server or attached client means no work.
    let Ok(output) = Command::new("tmux")
        .args(["list-clients", "-F", "#{client_tty}"])
        .output()
    else {
        return Vec::new();
    };
    if !output.status.success() {
        return Vec::new();
    }

    let mut terminals = Vec::new();
    for path in String::from_utf8_lossy(&output.stdout).lines() {
        if path.is_empty() {
            continue;
        }
        // Do not acquire a controlling terminal or block behind a busy client.
        let terminal = OpenOptions::new()
            .write(true)
            .custom_flags(libc::O_NOCTTY | libc::O_NONBLOCK)
            .open(path);
        match terminal {
            Ok(terminal) => terminals.push(terminal),
            Err(error) => eprintln!("appearancectl: could not open terminal {path}: {error}"),
        }
    }
    terminals
}
