import Quickshell
import QtQuick
import Qt.labs.folderlistmodel
import qs.modules

// Theme > Colors: one entry per palette in ~/.config/themes/palettes, Enter runs
// theme-switcher.sh, which regenerates every app's colors.
Launcher {
    entries: palettes.instances

    FolderListModel {
        id: folder

        folder: "file://" + Quickshell.env("HOME") + "/.config/themes/palettes"
        nameFilters: ["*.json"]
        showDirs: false
    }

    Variants {
        id: palettes

        // FolderListModel only hands out files one by one, so collect the names.
        model: Array.from({ length: folder.count }, (_, index) => folder.get(index, "fileBaseName"))

        LauncherEntry {
            required property string modelData

            // "cyan" → "Cyan"
            title: modelData.charAt(0).toUpperCase() + modelData.slice(1)
            onTriggered: Quickshell.execDetached([Quickshell.env("HOME") + "/.config/hypr/scripts/theme-switcher.sh", modelData])
        }
    }
}
