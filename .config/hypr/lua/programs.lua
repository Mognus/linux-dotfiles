return {
    terminal = { command = "alacritty", workspace = "term", key = "Return" },
    browser = { command = "librewolf", workspace = "browser", key = "B" },
    discord = { command = "discord", workspace = "discord", key = "D" },
    chat = { command = "simplex-chat-desktop", workspace = "chat", key = "C" },
    notes = { command = "obsidian", workspace = "notes", key = "N" },
    files = { command = "thunar", workspace = "files", key = "F" },
    music = { command = "chromium --app=https://music.youtube.com", workspace = "music", key = "M" },
    reader = { command = "foliate", workspace = "reader", key = "R" },
    lock = { command = "qs -n -d -p $HOME/.config/quickshell/lock.qml" },
}
