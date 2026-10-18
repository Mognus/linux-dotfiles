use std::fs;
use std::process::{Command, Output};

use serde_json::Value;
use tempfile::TempDir;
use toml_edit::DocumentMut;

fn command(state: &TempDir, args: &[&str]) -> Command {
    let mut command = Command::new(env!("CARGO_BIN_EXE_appearancectl"));
    command.env("THEME_STATE_DIR", state.path()).args(args);
    command
}

fn run(state: &TempDir, args: &[&str]) -> Output {
    let output = command(state, args).output().unwrap();
    assert!(
        output.status.success(),
        "{}",
        String::from_utf8_lossy(&output.stderr)
    );
    output
}

fn get(state: &TempDir) -> Value {
    serde_json::from_slice(&run(state, &["get"]).stdout).unwrap()
}

#[test]
fn initializes_old_color_only_files_without_losing_existing_data() {
    let state = TempDir::new().unwrap();
    fs::write(
        state.path().join("alacritty.toml"),
        "# Keep this comment\n[colors.primary]\nbackground = '#112233'\n[custom]\nkeep = true\n",
    )
    .unwrap();
    run(&state, &["init"]);
    assert_eq!(
        get(&state),
        serde_json::json!({"opacity": 0.93, "font_size": 20.0, "padding": 12})
    );
    let contents = fs::read_to_string(state.path().join("alacritty.toml")).unwrap();
    let document: DocumentMut = contents.parse().unwrap();
    assert!(contents.contains("# Keep this comment"));
    assert_eq!(
        document["colors"]["primary"]["background"].as_str(),
        Some("#112233")
    );
    assert_eq!(document["custom"]["keep"].as_bool(), Some(true));
}

#[test]
fn theme_and_terminal_changes_preserve_each_others_fields() {
    let state = TempDir::new().unwrap();
    let palette = state.path().join("palette.json");
    fs::write(&palette, r##"{"background":"#ffffff","foregroundSoft":"#333333","accent":"#007aff","terminalBackground":"#222222"}"##).unwrap();
    run(&state, &["terminal", "opacity", "0.6"]);
    run(&state, &["terminal", "font-size", "23.5"]);
    run(&state, &["terminal", "padding", "8"]);
    run(&state, &["theme", palette.to_str().unwrap()]);
    assert_eq!(
        get(&state),
        serde_json::json!({"opacity": 0.6, "font_size": 23.5, "padding": 8})
    );
    run(&state, &["terminal", "opacity", "0.9"]);
    let document: DocumentMut = fs::read_to_string(state.path().join("alacritty.toml"))
        .unwrap()
        .parse()
        .unwrap();
    assert_eq!(
        document["colors"]["primary"]["background"].as_str(),
        Some("#222222")
    );
    assert_eq!(
        document["colors"]["primary"]["foreground"].as_str(),
        Some("#333333")
    );
    run(&state, &["terminal", "reset"]);
    assert_eq!(
        get(&state),
        serde_json::json!({"opacity": 0.93, "font_size": 20.0, "padding": 12})
    );
    let document: DocumentMut = fs::read_to_string(state.path().join("alacritty.toml"))
        .unwrap()
        .parse()
        .unwrap();
    assert_eq!(
        document["colors"]["primary"]["background"].as_str(),
        Some("#222222")
    );
}

#[test]
fn invalid_changes_and_broken_toml_leave_the_file_untouched() {
    let state = TempDir::new().unwrap();
    run(&state, &["init"]);
    let path = state.path().join("alacritty.toml");
    let before = fs::read_to_string(&path).unwrap();
    for args in [
        ["terminal", "opacity", "NaN"],
        ["terminal", "opacity", "1.1"],
        ["terminal", "font-size", "5"],
        ["terminal", "padding", "1.5"],
        ["terminal", "padding", "49"],
    ] {
        assert!(!command(&state, &args).output().unwrap().status.success());
        assert_eq!(fs::read_to_string(&path).unwrap(), before);
    }
    fs::write(&path, "[broken").unwrap();
    assert!(
        !command(&state, &["init"])
            .output()
            .unwrap()
            .status
            .success()
    );
    assert_eq!(fs::read_to_string(&path).unwrap(), "[broken");
}

#[test]
fn concurrent_theme_and_slider_writes_do_not_lose_settings() {
    let state = TempDir::new().unwrap();
    let palette = state.path().join("palette.json");
    fs::write(
        &palette,
        r##"{"background":"#ffffff","foregroundSoft":"#333333","accent":"#007aff"}"##,
    )
    .unwrap();
    let mut children = Vec::new();
    for _ in 0..6 {
        for args in [
            vec!["terminal", "opacity", "0.61"],
            vec!["terminal", "font-size", "24.5"],
            vec!["terminal", "padding", "7"],
            vec!["theme", palette.to_str().unwrap()],
        ] {
            children.push(
                command(&state, &args)
                    .stdout(std::process::Stdio::null())
                    .spawn()
                    .unwrap(),
            );
        }
    }
    for mut child in children {
        assert!(child.wait().unwrap().success());
    }
    assert_eq!(
        get(&state),
        serde_json::json!({"opacity": 0.61, "font_size": 24.5, "padding": 7})
    );
    let document: DocumentMut = fs::read_to_string(state.path().join("alacritty.toml"))
        .unwrap()
        .parse()
        .unwrap();
    assert_eq!(
        document["colors"]["primary"]["background"].as_str(),
        Some("#ffffff")
    );
}
