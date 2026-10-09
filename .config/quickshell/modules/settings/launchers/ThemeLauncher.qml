import QtQuick
import qs.modules
import qs.modules.settings.launchers.theme

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
            page: Component {
                ColorsLauncher {}
            }
        }
    ]
}
