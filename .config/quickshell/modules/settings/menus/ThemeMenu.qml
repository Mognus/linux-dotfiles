import QtQuick
import qs.modules
import qs.modules.settings.menus.theme

// Theme sub menu of the settings: wallpaper and colors.
Menu {
    entries: [
        MenuEntry {
            title: "Wallpaper"
            page: Component {
                WallpaperMenu {}
            }
        },
        MenuEntry {
            title: "Colors"
            page: Component {
                ColorsMenu {}
            }
        }
    ]
}
