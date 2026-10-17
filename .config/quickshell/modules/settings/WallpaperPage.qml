import Quickshell
import QtQuick
import Qt.labs.folderlistmodel
import qs
import qs.modules
import "../../lib/Navigation.js" as Navigation

// Selection previews a file; only confirmation hands it to awww.
FocusScope {
    id: view

    property bool searching: false
    readonly property var entries: Array.from({ length: folder.count }, (_, index) => ({
        name: folder.get(index, "fileBaseName"),
        path: folder.get(index, "filePath"),
        url: folder.get(index, "fileUrl")
    }))
    readonly property var matches: view.entries.filter(entry => entry.name.toLowerCase().includes(search.text.toLowerCase()))
    readonly property var current: view.matches[list.currentIndex] ?? null

    focus: true

    function applyCurrent() {
        if (view.current) {
            Quickshell.execDetached(["awww", "img", view.current.path, "--transition-type", "any", "--transition-duration", "1", "--transition-fps", "60"]);
        }
    }

    onMatchesChanged: list.currentIndex = view.matches.length > 0 ? 0 : -1

    FolderListModel {
        id: folder

        folder: "file://" + Quickshell.env("HOME") + "/.config/wallpapers"
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp", "*.gif"]
        caseSensitive: false
        showDirs: false
        sortField: FolderListModel.Name
    }

    ListView {
        id: list

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: view.searching ? search.top : hint.top
        anchors.bottomMargin: 12
        width: 310
        clip: true
        focus: true
        model: view.matches
        currentIndex: 0

        Keys.onPressed: event => {
            if (Navigation.isListDown(event)) {
                list.incrementCurrentIndex();
            } else if (Navigation.isListUp(event)) {
                list.decrementCurrentIndex();
            } else if (Navigation.isConfirm(event)) {
                view.applyCurrent();
            } else if (event.key === Qt.Key_Slash) {
                view.searching = true;
                search.forceActiveFocus();
            } else {
                return;
            }
            event.accepted = true;
        }

        delegate: Rectangle {
            id: row

            required property var modelData
            required property int index

            width: ListView.view.width
            height: 36
            color: row.ListView.isCurrentItem ? Colors.hoverOverlay : "transparent"

            Text {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10
                anchors.verticalCenter: parent.verticalCenter
                text: row.modelData.name
                textFormat: Text.PlainText
                elide: Text.ElideRight
                color: row.ListView.isCurrentItem ? Colors.accent : Colors.foregroundSoft
                font.family: Fonts.family
                font.pixelSize: Fonts.size
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

    Item {
        id: searchKeys

        Keys.onPressed: event => {
            if (Navigation.isDown(event)) {
                list.incrementCurrentIndex();
            } else if (Navigation.isUp(event)) {
                list.decrementCurrentIndex();
            } else if (Navigation.isConfirm(event)) {
                view.applyCurrent();
            } else if (Navigation.isCancel(event)) {
                search.clear();
                view.searching = false;
                list.forceActiveFocus();
            } else {
                return;
            }
            event.accepted = true;
        }
    }

    SearchFooter {
        id: search

        anchors.left: parent.left
        anchors.bottom: hint.top
        anchors.bottomMargin: 12
        width: list.width
        height: 36
        visible: view.searching
        keyTargets: [searchKeys]
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
        anchors.bottom: hint.top
        anchors.bottomMargin: 12
        text: view.current ? view.current.path.split("/").pop() : ""
        textFormat: Text.PlainText
        elide: Text.ElideMiddle
        color: Colors.foregroundSoft
        font.family: Fonts.family
        font.pixelSize: Fonts.captionSize
    }

    Text {
        id: hint

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: view.searching ? "Type to filter   CTRL+J/K select   ENTER apply   ESC clear search" : "J/K select   / search   ENTER apply   ESC back"
        color: Colors.muted
        font.family: Fonts.family
        font.pixelSize: Fonts.captionSize
    }
}
