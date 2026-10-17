import QtQuick
import qs
import "../lib/Navigation.js" as Navigation

// Entries provide a name; all other fields are passed through to the caller.
// Pages own their previews and actions, not this list.
FocusScope {
    id: root

    property var entries: []
    property alias delegate: list.delegate
    property bool searching: false
    readonly property var matches: Array.from(root.entries).filter(entry => entry.name.toLowerCase().includes(search.text.toLowerCase()))
    readonly property var current: root.matches[list.currentIndex] ?? null
    readonly property string helpText: root.searching ? "Type to filter   CTRL+J/K select   ENTER apply   ESC clear search" : "J/K select   / search   ENTER apply   ESC back"

    signal activated(var entry)

    focus: true

    function select(index) {
        list.currentIndex = index;
        list.forceActiveFocus();
    }

    function activateCurrent() {
        if (root.current) {
            root.activated(root.current);
        }
    }

    function startSearch() {
        root.searching = true;
        search.forceActiveFocus();
    }

    function stopSearch() {
        search.clear();
        root.searching = false;
        list.forceActiveFocus();
    }

    onMatchesChanged: list.currentIndex = root.matches.length > 0 ? 0 : -1

    ListView {
        id: list

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: root.searching ? search.top : parent.bottom
        anchors.bottomMargin: root.searching ? 12 : 0
        clip: true
        focus: true
        model: root.matches
        currentIndex: 0

        Keys.onPressed: event => {
            if (Navigation.isListDown(event)) {
                list.incrementCurrentIndex();
            } else if (Navigation.isListUp(event)) {
                list.decrementCurrentIndex();
            } else if (Navigation.isConfirm(event)) {
                root.activateCurrent();
            } else if (event.key === Qt.Key_Slash) {
                root.startSearch();
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
                onClicked: root.select(row.index)
                onDoubleClicked: root.activateCurrent()
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
                root.activateCurrent();
            } else if (Navigation.isCancel(event)) {
                root.stopSearch();
            } else {
                return;
            }
            event.accepted = true;
        }
    }

    SearchFooter {
        id: search

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 36
        visible: root.searching
        keyTargets: [searchKeys]
    }
}
