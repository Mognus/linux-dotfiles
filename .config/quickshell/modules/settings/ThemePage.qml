import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel
import qs
import qs.modules
import "theme"

// Highlighting only changes the previews; Enter applies the selected palette.
FocusScope {
    id: view

    readonly property var previewPalette: list.current ? list.current.themeColors : null
    property string activeTheme: ""

    focus: true

    FolderListModel {
        id: folder

        folder: "file://" + Quickshell.env("HOME") + "/.config/themes/palettes"
        nameFilters: ["*.json"]
        showDirs: false
        sortField: FolderListModel.Name
    }

    // Keep palette data outside list delegates so search can inspect every name.
    Variants {
        id: palettes

        model: Array.from({ length: folder.count }, (_, index) => ({
            name: folder.get(index, "fileBaseName"),
            path: folder.get(index, "filePath")
        }))

        Scope {
            id: entry

            required property var modelData
            readonly property string fileBaseName: entry.modelData.name
            readonly property string palettePath: entry.modelData.path
            readonly property string name: entry.themeColors ? entry.themeColors.name : entry.fileBaseName
            property var themeColors: null

            FileView {
                id: paletteFile

                path: entry.palettePath
                watchChanges: true
                onFileChanged: reload()
                onLoaded: {
                    try {
                        entry.themeColors = JSON.parse(paletteFile.text());
                    } catch (error) {
                        entry.themeColors = null;
                        console.warn("Invalid theme palette:", entry.palettePath, error);
                    }
                }
                onLoadFailed: entry.themeColors = null
            }
        }
    }

    FileView {
        id: currentTheme

        path: ThemePaths.stateDir + "/current"
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: view.activeTheme = currentTheme.text().trim()
    }

    SearchableList {
        id: list

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: footer.top
        anchors.bottomMargin: 12
        width: 240
        entries: palettes.instances

        onActivated: entry => {
            if (entry.themeColors) {
                Quickshell.execDetached([ThemePaths.binary, "theme", entry.palettePath]);
            }
        }

        delegate: Rectangle {
            id: row

            required property var modelData
            required property int index

            width: ListView.view.width
            height: 52
            color: row.ListView.isCurrentItem ? Colors.hoverOverlay : "transparent"

            Column {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    text: row.modelData.name + (view.activeTheme === row.modelData.fileBaseName ? " *" : "")
                    textFormat: Text.PlainText
                    color: row.ListView.isCurrentItem ? Colors.accent : Colors.foreground
                    font.family: Fonts.family
                    font.pixelSize: Fonts.size
                }

                Text {
                    text: row.modelData.themeColors ? row.modelData.themeColors.mode.toUpperCase() : "LOADING"
                    color: Colors.muted
                    font.family: Fonts.family
                    font.pixelSize: Fonts.captionSize
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: list.select(row.index)
                onDoubleClicked: list.activateCurrent()
            }
        }
    }

    Column {
        id: previews

        anchors.top: parent.top
        anchors.left: list.right
        anchors.leftMargin: 20
        anchors.right: parent.right
        spacing: 12
        visible: view.previewPalette !== null

        TerminalPreview {
            width: parent.width
            height: 180
            themeColors: view.previewPalette
        }

        BrowserPreview {
            width: parent.width
            height: 210
            themeColors: view.previewPalette
        }
    }

    Text {
        anchors.centerIn: previews
        visible: view.previewPalette === null
        text: folder.count === 0 ? "No themes found" : list.matches.length === 0 ? "No matches" : "Preview unavailable"
        color: Colors.muted
        font.family: Fonts.family
        font.pixelSize: Fonts.size
    }

    Text {
        id: footer

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: list.helpText + (list.searching ? "" : "   * active theme")
        color: Colors.muted
        font.family: Fonts.family
        font.pixelSize: Fonts.captionSize
    }
}
