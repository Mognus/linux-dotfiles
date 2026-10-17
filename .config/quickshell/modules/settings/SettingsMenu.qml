import Quickshell
import Quickshell.Wayland
import QtQuick
import qs
import qs.modules
import qs.services
import "../../lib/Navigation.js" as Navigation

// Settings owns one level of navigation; each page only supplies its content.
OverlayWindow {
    id: window

    readonly property int padding: 12
    readonly property int headerHeight: 44
    property string currentPage: ""

    function back() {
        if (window.currentPage === "") {
            ShellState.closeSettings();
        } else {
            window.currentPage = "";
            start.forceActiveFocus();
        }
    }

    visible: ShellState.settingsOpen
    panelWidth: window.currentPage === "Wallpaper" ? 1100 : window.currentPage === "Theme" ? 960 : 600
    panelHeight: window.headerHeight + divider.height + (window.currentPage === "Wallpaper" ? 520 : window.currentPage === "Theme" ? 440 : 340) + window.padding * 2

    // Name that Hyprland layer rules can match.
    WlrLayershell.namespace: "settings"

    // Every opening starts at the top of the list.
    onVisibleChanged: {
        if (window.visible) {
            window.currentPage = "";
            start.currentIndex = 0;
            start.forceActiveFocus();
        }
    }

    Breadcrumbs {
        id: header

        // No top margin: the header's own height centers the crumbs between edge and divider.
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: window.padding
            rightMargin: window.padding
        }

        height: window.headerHeight
        path: window.currentPage === "" ? [] : [window.currentPage]
        onCloseRequested: ShellState.closeSettings()
    }

    Rectangle {
        id: divider

        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
        }

        height: 1
        color: Colors.divider
    }

    FocusScope {
        id: content

        anchors {
            top: divider.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: window.padding
        }

        focus: true

        Keys.onPressed: event => {
            if (Navigation.isBack(event)) {
                window.back();
                event.accepted = true;
            }
        }

        ListView {
            id: start

            anchors.fill: parent
            visible: window.currentPage === ""
            focus: visible
            clip: true
            model: ["Theme", "Wallpaper", "Audio"]

            Keys.onPressed: event => {
                if (Navigation.isListDown(event)) {
                    start.incrementCurrentIndex();
                } else if (Navigation.isListUp(event)) {
                    start.decrementCurrentIndex();
                } else if (Navigation.isOpen(event)) {
                    window.currentPage = start.model[start.currentIndex];
                } else {
                    return;
                }
                event.accepted = true;
            }

            delegate: Rectangle {
                id: row

                required property string modelData
                required property int index

                width: ListView.view.width
                height: 36
                color: row.ListView.isCurrentItem ? Colors.hoverOverlay : "transparent"

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    text: row.modelData
                    color: row.ListView.isCurrentItem ? Colors.accent : Colors.foregroundSoft
                    font.family: Fonts.family
                    font.pixelSize: Fonts.size
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        start.currentIndex = row.index;
                        window.currentPage = row.modelData;
                    }
                }
            }
        }

        Loader {
            id: page

            anchors.fill: parent
            active: window.currentPage !== ""
            focus: active
            sourceComponent: {
                switch (window.currentPage) {
                case "Theme": return themePage;
                case "Wallpaper": return wallpaperPage;
                case "Audio": return audioPage;
                default: return null;
                }
            }
            onLoaded: page.item.forceActiveFocus()
        }
    }

    Component {
        id: themePage
        ThemePage {}
    }

    Component {
        id: wallpaperPage
        WallpaperPage {}
    }

    Component {
        id: audioPage
        AudioPage {}
    }
}
