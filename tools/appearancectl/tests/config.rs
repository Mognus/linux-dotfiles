use std::fs;
use std::os::unix::fs::PermissionsExt;
use std::process::{Command, Output};

use serde_json::Value;
use tempfile::TempDir;
use toml_edit::DocumentMut;

fn command(state: &TempDir, args: &[&str]) -> Command {
    let mut command = Command::new(env!("CARGO_BIN_EXE_appearancectl"));
    // Only the child uses this HOME/PATH; tests never touch the desktop's dconf.
    command
        .env("HOME", state.path())
        .env("PATH", state.path().join("bin"))
        .args(args);
    command
}

fn test_home() -> TempDir {
    let home = TempDir::new().unwrap();
    let bin = home.path().join("bin");
    fs::create_dir(&bin).unwrap();
    let dconf = bin.join("dconf");
    fs::write(
        &dconf,
        "#!/bin/sh\nprintf '%s\\n' \"$@\" >> \"$HOME/dconf.log\"\n",
    )
    .unwrap();
    fs::set_permissions(&dconf, fs::Permissions::from_mode(0o755)).unwrap();
    let notify = bin.join("notify-send");
    fs::write(
        &notify,
        "#!/bin/sh\nprintf '%s\\n' \"$@\" >> \"$HOME/notify.log\"\n",
    )
    .unwrap();
    fs::set_permissions(&notify, fs::Permissions::from_mode(0o755)).unwrap();
    home
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
    let state = test_home();
    fs::create_dir_all(state.path().join(".local/state/dotfiles-theme")).unwrap();
    fs::write(
        state
            .path()
            .join(".local/state/dotfiles-theme/alacritty.toml"),
        "# Keep this comment\n[colors.primary]\nbackground = '#112233'\n[custom]\nkeep = true\n",
    )
    .unwrap();
    run(&state, &["init"]);
    assert_eq!(
        get(&state),
        serde_json::json!({"opacity": 0.93, "font_size": 20.0, "padding": 12})
    );
    let contents = fs::read_to_string(
        state
            .path()
            .join(".local/state/dotfiles-theme/alacritty.toml"),
    )
    .unwrap();
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
    let state = test_home();
    let palette = state.path().join("palette.json");
    fs::write(&palette, r##"{"name":"Test Light","mode":"light","background":"#ffffff","surface":"#eeeeee","foreground":"#111111","foregroundSoft":"#333333","accent":"#007aff","terminalBackground":"#222222"}"##).unwrap();
    run(&state, &["terminal", "opacity", "0.6"]);
    run(&state, &["terminal", "font-size", "23.5"]);
    run(&state, &["terminal", "padding", "8"]);
    run(&state, &["theme", palette.to_str().unwrap()]);
    assert_eq!(
        get(&state),
        serde_json::json!({"opacity": 0.6, "font_size": 23.5, "padding": 8})
    );
    run(&state, &["terminal", "opacity", "0.9"]);
    let document: DocumentMut = fs::read_to_string(
        state
            .path()
            .join(".local/state/dotfiles-theme/alacritty.toml"),
    )
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
    let document: DocumentMut = fs::read_to_string(
        state
            .path()
            .join(".local/state/dotfiles-theme/alacritty.toml"),
    )
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
    let state = test_home();
    run(&state, &["init"]);
    let path = state
        .path()
        .join(".local/state/dotfiles-theme/alacritty.toml");
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
    let state = test_home();
    let palette = state.path().join("palette.json");
    fs::write(
        &palette,
        r##"{"name":"Test Dark","mode":"dark","background":"#ffffff","surface":"#111111","foreground":"#eeeeee","foregroundSoft":"#333333","accent":"#007aff"}"##,
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
    let document: DocumentMut = fs::read_to_string(
        state
            .path()
            .join(".local/state/dotfiles-theme/alacritty.toml"),
    )
    .unwrap()
    .parse()
    .unwrap();
    assert_eq!(
        document["colors"]["primary"]["background"].as_str(),
        Some("#ffffff")
    );
}

#[test]
fn every_repository_palette_generates_shell_gtk_and_terminal_files() {
    let home = test_home();
    let palette_dir =
        std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../.config/themes/palettes");
    let state_dir = home.path().join(".local/state/dotfiles-theme");

    for entry in fs::read_dir(palette_dir).unwrap() {
        let palette_path = entry.unwrap().path();
        if palette_path
            .extension()
            .is_none_or(|extension| extension != "json")
        {
            continue;
        }
        let palette: Value =
            serde_json::from_str(&fs::read_to_string(&palette_path).unwrap()).unwrap();
        run(&home, &["theme", palette_path.to_str().unwrap()]);

        let generated: Value =
            serde_json::from_str(&fs::read_to_string(state_dir.join("colors.json")).unwrap())
                .unwrap();
        assert_eq!(generated, palette, "{}", palette_path.display());
        let terminal: DocumentMut = fs::read_to_string(state_dir.join("alacritty.toml"))
            .unwrap()
            .parse()
            .unwrap();
        let background = palette
            .get("terminalBackground")
            .unwrap_or(&palette["background"]);
        let foreground = palette
            .get("terminalForeground")
            .unwrap_or(&palette["foregroundSoft"]);
        assert_eq!(
            terminal["colors"]["primary"]["background"].as_str(),
            background.as_str()
        );
        assert_eq!(
            terminal["colors"]["primary"]["foreground"].as_str(),
            foreground.as_str()
        );
        assert_eq!(
            fs::read_to_string(state_dir.join("current"))
                .unwrap()
                .trim(),
            palette_path.file_stem().unwrap().to_str().unwrap(),
        );
        let css = fs::read_to_string(state_dir.join("gtk.css")).unwrap();
        assert!(css.contains(&format!(
            "@define-color theme_bg_color {};",
            palette["background"].as_str().unwrap()
        )));
        assert!(css.contains(&format!(
            "@define-color theme_base_color {};",
            palette["surface"].as_str().unwrap()
        )));
    }
}

#[test]
fn restore_uses_default_then_saved_theme_without_notifications() {
    let home = test_home();
    let palette_dir = home.path().join(".config/themes/palettes");
    fs::create_dir_all(&palette_dir).unwrap();
    fs::write(
        palette_dir.join("retro-dark.json"),
        include_str!("../../../.config/themes/palettes/retro-dark.json"),
    )
    .unwrap();
    fs::write(
        palette_dir.join("light-gray.json"),
        include_str!("../../../.config/themes/palettes/light-gray.json"),
    )
    .unwrap();
    let state_dir = home.path().join(".local/state/dotfiles-theme");

    run(&home, &["restore"]);
    assert_eq!(
        fs::read_to_string(state_dir.join("current")).unwrap(),
        "retro-dark\n"
    );
    assert_eq!(
        fs::read_to_string(home.path().join("dconf.log")).unwrap(),
        "write\n/org/gnome/desktop/interface/gtk-theme\n'Adwaita-dark'\nwrite\n/org/gnome/desktop/interface/color-scheme\n'prefer-dark'\n"
    );

    run(
        &home,
        &[
            "theme",
            palette_dir.join("light-gray.json").to_str().unwrap(),
        ],
    );
    assert!(home.path().join("notify.log").exists());
    fs::remove_file(home.path().join("notify.log")).unwrap();
    fs::remove_file(home.path().join("dconf.log")).unwrap();
    fs::remove_file(state_dir.join("colors.json")).unwrap();
    run(&home, &["restore"]);

    assert!(!home.path().join("notify.log").exists());
    assert_eq!(
        fs::read_to_string(state_dir.join("current")).unwrap(),
        "light-gray\n"
    );
    assert_eq!(
        fs::read_to_string(home.path().join("dconf.log")).unwrap(),
        "write\n/org/gnome/desktop/interface/gtk-theme\n'Adwaita'\nwrite\n/org/gnome/desktop/interface/color-scheme\n'prefer-light'\n"
    );
    let colors: Value =
        serde_json::from_str(&fs::read_to_string(state_dir.join("colors.json")).unwrap()).unwrap();
    assert_eq!(colors["name"], "Light Gray");
}

#[test]
fn invalid_palette_does_not_change_existing_state() {
    let home = test_home();
    run(&home, &["init"]);
    let terminal_path = home
        .path()
        .join(".local/state/dotfiles-theme/alacritty.toml");
    let before = fs::read_to_string(&terminal_path).unwrap();
    let palette_path = home.path().join("invalid.json");
    let mut palette: Value = serde_json::from_str(include_str!(
        "../../../.config/themes/palettes/retro-dark.json"
    ))
    .unwrap();
    for (field, invalid_value) in [
        ("mode", "unknown"),
        ("accent", "green"),
        ("surface", "#123"),
    ] {
        let original = palette[field].clone();
        palette[field] = Value::String(invalid_value.to_owned());
        fs::write(&palette_path, serde_json::to_string(&palette).unwrap()).unwrap();
        assert!(
            !command(&home, &["theme", palette_path.to_str().unwrap()])
                .output()
                .unwrap()
                .status
                .success()
        );
        assert_eq!(fs::read_to_string(&terminal_path).unwrap(), before);
        palette[field] = original;
    }
    assert!(!home.path().join("dconf.log").exists());
}

#[test]
fn failed_gtk_preference_does_not_mark_theme_as_applied() {
    let home = test_home();
    fs::write(home.path().join("bin/dconf"), "#!/bin/sh\nexit 1\n").unwrap();
    let palette_path = home.path().join("retro-dark.json");
    fs::write(
        &palette_path,
        include_str!("../../../.config/themes/palettes/retro-dark.json"),
    )
    .unwrap();
    let result = command(&home, &["theme", palette_path.to_str().unwrap()])
        .output()
        .unwrap();
    assert!(!result.status.success());
    assert!(String::from_utf8_lossy(&result.stderr).contains("dconf write gtk-theme failed"));
    assert!(
        !home
            .path()
            .join(".local/state/dotfiles-theme/current")
            .exists()
    );
    assert!(!home.path().join("notify.log").exists());
}

#[test]
fn theme_change_queries_attached_terminals_but_slider_changes_do_not() {
    let home = test_home();
    let tmux = home.path().join("bin/tmux");
    fs::write(&tmux, "#!/bin/sh\nprintf '%s\\n' \"$@\" >> \"$HOME/tmux.log\"\nprintf '%s\\n' \"$HOME/terminal-output\"\n").unwrap();
    fs::set_permissions(&tmux, fs::Permissions::from_mode(0o755)).unwrap();
    let terminal = home.path().join("terminal-output");
    fs::write(&terminal, "").unwrap();
    let palette = home.path().join("retro-dark.json");
    fs::write(
        &palette,
        include_str!("../../../.config/themes/palettes/retro-dark.json"),
    )
    .unwrap();

    run(&home, &["theme", palette.to_str().unwrap()]);
    let expected_queries = b"\x1b]10;?\x07\x1b]11;?\x07\x1b]10;?\x07\x1b]11;?\x07";
    assert_eq!(fs::read(&terminal).unwrap(), expected_queries);
    assert_eq!(
        fs::read_to_string(home.path().join("tmux.log")).unwrap(),
        "list-clients\n-F\n#{client_tty}\n"
    );

    fs::remove_file(home.path().join("tmux.log")).unwrap();
    run(&home, &["terminal", "padding", "8"]);
    assert!(!home.path().join("tmux.log").exists());
    assert_eq!(fs::read(&terminal).unwrap(), expected_queries);
}
