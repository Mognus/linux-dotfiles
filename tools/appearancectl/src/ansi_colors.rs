use toml_edit::{DocumentMut, value};

use crate::palette::Palette;

/// Map palette roles to Alacritty's 16 ANSI slots, used by btop and other TUIs.
pub fn apply(document: &mut DocumentMut, palette: &Palette, background: &str, foreground: &str) {
    let colors = [
        ("red", &palette.danger),
        ("green", &palette.success),
        ("yellow", &palette.warning),
        ("blue", &palette.secondary),
        ("magenta", &palette.violet),
        ("cyan", &palette.accent),
    ];

    // The palette supplies one color per role, shared by normal/bright ANSI slots.
    // Keep text tied to the terminal foreground, including Light Gray's dark terminal.
    for section in ["normal", "bright"] {
        for (name, color) in colors {
            document["colors"][section][name] = value(color);
        }
        document["colors"][section]["white"] = value(foreground);
    }
    document["colors"]["normal"]["black"] = value(background);
    document["colors"]["bright"]["black"] = value(&palette.muted);
}
