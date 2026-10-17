import Quickshell
import Quickshell.Wayland
import QtQuick
import qs
import qs.modules
import qs.services
import "../../lib/Navigation.js" as Navigation

// Categories group the start list; only content pages change the current page.
OverlayWindow {
    id: window

    readonly property int padding: 12
    readonly property int headerHeight: 44
    readonly property var sections: [
        {
            name: "General",
            entries: [
                { name: "Audio", component: audioPage, panelWidth: 600, contentHeight: 340 }
            ]
        },
        {
            name: "Appearance",
            entries: [
                { name: "Theme", component: themePage, panelWidth: 960, contentHeight: 440 },
                { name: "Wallpaper", component: wallpaperPage, panelWidth: 1100, contentHeight: 520 }
            ]
        },
        {
            name: "Launcher",
            entries: [
                { name: "Applications", action: () => ShellState.toggleLauncher() },
                { name: "Windows", action: () => ShellState.toggleWindowSwitcher() },
                { name: "Clipboard", action: () => ShellState.toggleClipboard() }
            ]
        }
    ]
    readonly property var entries: {
        const result = [];
        for (const section of window.sections) {
            for (const entry of section.entries) {
                result.push(Object.assign({ category: section.name }, entry));
            }
        }
        return result;
    }
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
        path: window.currentPage ? [window.currentPage.category, window.currentPage.name] : []
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
            entries: window.entries
            sectionRole: "category"
            onActivated: entry => {
                start.stopSearch();
                if (entry.action) {
                    entry.action();
                } else {
                    window.currentPage = entry;
                }
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
