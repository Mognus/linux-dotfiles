import Quickshell
import QtQuick
import Qt.labs.folderlistmodel
import qs.modules

// Theme > Wallpaper: one entry per image in ~/.config/wallpapers, Enter hands it to awww.
Menu {
    entries: wallpapers.instances

    FolderListModel {
        id: folder

        folder: "file://" + Quickshell.env("HOME") + "/.config/wallpapers"
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp", "*.gif"]
        caseSensitive: false
        showDirs: false
    }

    Variants {
        id: wallpapers

        // FolderListModel only hands out files one by one, so collect the paths.
        model: Array.from({ length: folder.count }, (_, index) => folder.get(index, "filePath"))

        MenuEntry {
            required property string modelData

            // "/home/magnus/.config/wallpapers/lynx.jpg" → "lynx"
            title: modelData.split("/").pop().replace(/\.[^.]+$/, "")
            onTriggered: Quickshell.execDetached(["awww", "img", modelData, "--transition-type", "any", "--transition-duration", "1", "--transition-fps", "60"])
        }
    }
}
