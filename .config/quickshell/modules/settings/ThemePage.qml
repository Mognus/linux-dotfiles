import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel
import qs
import "../../lib/Navigation.js" as Navigation
import "theme"

// Highlighting only changes the previews; Enter applies the selected palette.
FocusScope {
    id: view

    readonly property var selectedRow: list.currentItem
    readonly property var previewPalette: view.selectedRow ? view.selectedRow.themeColors : null
    property string activeTheme: ""

    focus: true

    function applyCurrent() {
        if (view.previewPalette) {
            const name = view.selectedRow.fileBaseName;
            Quickshell.execDetached([Quickshell.env("HOME") + "/.config/hypr/scripts/theme-switcher.sh", name]);
        }
    }

    FolderListModel {
        id: folder

        folder: "file://" + Quickshell.env("HOME") + "/.config/themes/palettes"
        nameFilters: ["*.json"]
        showDirs: false
        sortField: FolderListModel.Name
    }

    FileView {
        id: currentTheme

        path: Quickshell.env("HOME") + "/.local/state/dotfiles-theme/current"
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: view.activeTheme = currentTheme.text().trim()
    }

    ListView {
        id: list

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: footer.top
        anchors.bottomMargin: 12
        width: 240
        clip: true
        focus: true
        model: folder
        currentIndex: 0

        Keys.onPressed: event => {
            if (Navigation.isListDown(event)) {
                list.incrementCurrentIndex();
            } else if (Navigation.isListUp(event)) {
                list.decrementCurrentIndex();
            } else if (Navigation.isConfirm(event)) {
                view.applyCurrent();
            } else {
                return;
            }
            event.accepted = true;
        }

        delegate: Rectangle {
            id: row

            required property string fileBaseName
            required property string filePath
            required property int index
            property var themeColors: null

            width: ListView.view.width
            height: 52
            color: row.ListView.isCurrentItem ? Colors.hoverOverlay : "transparent"

            FileView {
                id: paletteFile

                path: row.filePath
                watchChanges: true
                onFileChanged: reload()
                onLoaded: {
                    try {
                        row.themeColors = JSON.parse(paletteFile.text());
                    } catch (error) {
                        row.themeColors = null;
                        console.warn("Invalid theme palette:", row.filePath, error);
                    }
                }
                onLoadFailed: row.themeColors = null
            }

            Column {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    text: (row.themeColors ? row.themeColors.name : row.fileBaseName) + (view.activeTheme === row.fileBaseName ? " *" : "")
                    color: row.ListView.isCurrentItem ? Colors.accent : Colors.foreground
                    font.family: Fonts.family
                    font.pixelSize: Fonts.size
                }

                Text {
                    text: row.themeColors ? row.themeColors.mode.toUpperCase() : "LOADING"
                    color: Colors.muted
                    font.family: Fonts.family
                    font.pixelSize: Fonts.captionSize
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    list.currentIndex = row.index;
                    list.forceActiveFocus();
                }
                onDoubleClicked: view.applyCurrent()
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
        text: folder.count === 0 ? "No themes found" : "Preview unavailable"
        color: Colors.muted
        font.family: Fonts.family
        font.pixelSize: Fonts.size
    }

    Text {
        id: footer

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: "J/K select   ENTER apply   ESC back   * active theme"
        color: Colors.muted
        font.family: Fonts.family
        font.pixelSize: Fonts.captionSize
    }
}
