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
    readonly property var pages: [
        { name: "Theme", component: themePage, panelWidth: 960, contentHeight: 440 },
        { name: "Wallpaper", component: wallpaperPage, panelWidth: 1100, contentHeight: 520 },
        { name: "Audio", component: audioPage, panelWidth: 600, contentHeight: 340 }
    ]
    property var currentPage: null

    function back() {
        if (window.currentPage === null) {
            ShellState.closeSettings();
        } else {
            window.currentPage = null;
            start.forceActiveFocus();
        }
    }

    visible: ShellState.settingsOpen
    panelWidth: window.currentPage ? window.currentPage.panelWidth : 600
    panelHeight: window.headerHeight + divider.height + (window.currentPage ? window.currentPage.contentHeight : 340) + window.padding * 2

    // Name that Hyprland layer rules can match.
    WlrLayershell.namespace: "settings"

    // Every opening starts at the top of the list.
    onVisibleChanged: {
        if (window.visible) {
            window.currentPage = null;
            start.stopSearch();
            start.select(0);
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
        path: window.currentPage ? [window.currentPage.name] : []
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
            } else if (window.currentPage === null && Navigation.isOpen(event)) {
                start.activateCurrent();
                event.accepted = true;
            }
        }

        SearchableList {
            id: start

            anchors.fill: parent
            visible: window.currentPage === null
            focus: visible
            entries: window.pages
            onActivated: entry => {
                start.stopSearch();
                window.currentPage = entry;
            }
        }

        Loader {
            id: page

            anchors.fill: parent
            active: window.currentPage !== null
            focus: active
            sourceComponent: window.currentPage ? window.currentPage.component : null
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
