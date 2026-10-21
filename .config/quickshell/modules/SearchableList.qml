import QtQuick
import qs
import qs.modules.search
import "../lib/Navigation.js" as Navigation

// Entries provide a name; all other fields are passed through to the caller.
// Pages own their previews and actions, not this list.
FocusScope {
    id: root

    property var entries: []
    property alias delegate: list.delegate
    property string sectionRole: ""
    property bool searching: false
    readonly property var matches: Array.from(root.entries).filter(entry => entry.name.toLowerCase().includes(search.text.toLowerCase()))
    readonly property var current: root.matches[list.currentIndex] ?? null

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

        // Sections are headings, not selectable rows; empty groups disappear
        // automatically because the model only contains matching entries.
        section.property: root.sectionRole
        section.delegate: Item {
            required property string section

            width: list.width
            height: 28

            Rectangle {
                id: lead

                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                width: 12
                height: 1
                color: Colors.borderMuted
            }

            Text {
                id: sectionLabel

                anchors.left: lead.right
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                text: section.toUpperCase()
                textFormat: Text.PlainText
                color: Colors.muted
                font.family: Fonts.family
                font.pixelSize: Fonts.smallSize
            }

            Rectangle {
                anchors.left: sectionLabel.right
                anchors.leftMargin: 8
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                height: 1
                color: Colors.borderMuted
            }
        }

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

    SearchField {
        id: search

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 36
        visible: root.searching
        keyTargets: [searchKeys]
    }
}
