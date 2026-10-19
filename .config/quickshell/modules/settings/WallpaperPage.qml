import Quickshell
import QtQuick
import Qt.labs.folderlistmodel
import qs
import qs.modules

// Selection previews a file; only confirmation hands it to awww.
OverlayPage {
    id: view

    title: "Appearance / Wallpaper"
    panelWidth: 1100
    contentHeight: 520
    searchEnabled: true
    searching: list.searching
    confirmLabel: "APPLY"

    readonly property var entries: Array.from({ length: folder.count }, (_, index) => ({
        name: folder.get(index, "fileBaseName"),
        path: folder.get(index, "filePath"),
        url: folder.get(index, "fileUrl")
    }))
    readonly property var current: list.current

    FolderListModel {
        id: folder

        folder: "file://" + Quickshell.env("HOME") + "/.config/wallpapers"
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp", "*.gif"]
        caseSensitive: false
        showDirs: false
        sortField: FolderListModel.Name
    }

    SearchableList {
        id: list

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: 310
        entries: view.entries
        onActivated: entry => Quickshell.execDetached(["awww", "img", entry.path, "--transition-type", "any", "--transition-duration", "1", "--transition-fps", "60"])
    }

    Rectangle {
        id: preview

        anchors.top: parent.top
        anchors.left: list.right
        anchors.right: parent.right
        anchors.bottom: caption.top
        anchors.leftMargin: 20
        anchors.bottomMargin: 12
        color: Colors.surface
        border.width: 1
        border.color: Colors.borderMuted

        Image {
            id: image

            anchors.fill: parent
            anchors.margins: 1
            source: view.current ? view.current.url : ""
            sourceSize: Qt.size(width, height)
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            cache: false
        }

        Text {
            anchors.centerIn: parent
            visible: image.status !== Image.Ready
            text: !view.current ? (folder.count === 0 ? "No wallpapers found" : "No matches") : image.status === Image.Error ? "Preview unavailable" : "Loading preview…"
            color: Colors.muted
            font.family: Fonts.family
            font.pixelSize: Fonts.size
        }
    }

    Text {
        id: caption

        anchors.left: preview.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: view.current ? view.current.path.split("/").pop() : ""
        textFormat: Text.PlainText
        elide: Text.ElideMiddle
        color: Colors.foregroundSoft
        font.family: Fonts.family
        font.pixelSize: Fonts.captionSize
    }
}
