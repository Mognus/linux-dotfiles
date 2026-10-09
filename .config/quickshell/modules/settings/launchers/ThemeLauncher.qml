import QtQuick
import qs.modules

// Theme sub menu of the settings: wallpaper and colors.
Launcher {
    entries: [
        LauncherEntry {
            title: "Wallpaper"
            page: Component {
                WallpaperLauncher {}
            }
        },
        LauncherEntry {
            title: "Colors"
        }
    ]
}
