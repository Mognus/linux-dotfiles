import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import qs
import qs.modules
import qs.modules.search
import qs.services
import qs.modules.keyboard
import "windows"

// Window switcher: the open windows of every workspace on the left, a live view
// of the highlighted one on the right. The search line is always active: typing
// filters by app and title, Up/Down or Ctrl+j/k move, Enter focuses.
OverlayPage {
    id: window

    // Sort by app so the native list can group the filtered results.
    readonly property var entries: Array.from(Hyprland.toplevels.values)
        .map(toplevel => ({ app: window.appOf(toplevel), toplevel: toplevel }))
        .sort((a, b) => a.app.localeCompare(b.app))
    readonly property var current: filter.matches[list.currentIndex]?.toplevel ?? null

    // "librewolf" for a LibreWolf window; empty until Wayland reports it.
    function appOf(toplevel) {
        return toplevel.wayland ? toplevel.wayland.appId : "";
    }

    // Icon from the app's desktop entry: "librewolf" → the LibreWolf icon, a
    // generic one when no entry fits.
    function iconOf(app) {
        const entry = DesktopEntries.heuristicLookup(app);
        return Quickshell.iconPath(entry ? entry.icon : "", "application-x-executable");
    }

    // App and title in one string to search in: "librewolf GitHub".
    function label(toplevel) {
        return window.appOf(toplevel) + " " + toplevel.title;
    }

    function jumpTo(toplevel) {
        // An open special workspace stays on top of the others; hide it unless the window lives in it.
        const target = toplevel.workspace ? toplevel.workspace.name : "";
        if (target !== Workspaces.activeSpecialWorkspace) {
            Workspaces.hideSpecialWorkspace();
        }
        // With the Lua config, dispatch takes a Lua dispatcher. Quickshell reports
        // the address without the 0x that Hyprland's window selector expects.
        Hyprland.dispatch(`hl.dsp.focus({ window = "address:0x${toplevel.address}" })`);
        ShellState.closeWindowSwitcher();
    }

    function jumpToCurrent() {
        if (window.current) {
            window.jumpTo(window.current);
        }
    }

    title: "WINDOWS"
    settingsTitle: "Launcher / Windows"
    panelWidth: LauncherStyle.listPanelWidth
    contentHeight: LauncherStyle.listPanelHeight - LauncherStyle.padding * 2
    padding: LauncherStyle.padding
    keyBindings: keys

    SearchFilter {
        id: filter
        entries: window.entries
        query: footer.text
        textFor: entry => window.label(entry.toplevel)
        onMatchesChanged: list.currentIndex = filter.matches.length ? 0 : -1
    }

    KeyBindings {
        id: keys
        actions: [
            { keys: [Qt.Key_Up], label: "SELECT", run: () => list.decrementCurrentIndex() },
            { keys: [Qt.Key_Down], label: "SELECT", run: () => list.incrementCurrentIndex() },
            { keys: [Qt.Key_K], modifiers: Qt.ControlModifier, label: "SELECT", run: () => list.decrementCurrentIndex() },
            { keys: [Qt.Key_J], modifiers: Qt.ControlModifier, label: "SELECT", run: () => list.incrementCurrentIndex() },
            { keys: [Qt.Key_Return, Qt.Key_Enter], label: "FOCUS", enabled: window.current !== null, run: () => window.jumpToCurrent() },
            { keys: [Qt.Key_Escape], label: ShellState.overlayFromSettings ? "BACK" : "CLOSE", run: () => ShellState.backOverlay() }
        ]
    }

    function activate() {
        Hyprland.refreshToplevels();
        footer.forceActiveFocus();
    }

    ListView {
        id: list

        anchors {
            top: parent.top
            left: parent.left
            bottom: footer.top
            bottomMargin: LauncherStyle.padding
        }

        width: LauncherStyle.listWidth
        clip: true
        model: filter.matches

        // A header with icon and app name above each app's windows; the model is
        // sorted by app, so each app gets one.
        section.property: "app"
        section.delegate: Item {
            id: header

            required property string section

            width: list.width
            height: LauncherStyle.rowHeight

            IconImage {
                id: icon

                anchors {
                    left: parent.left
                    leftMargin: LauncherStyle.contentInset
                    verticalCenter: parent.verticalCenter
                }

                implicitSize: LauncherStyle.listIconSize
                asynchronous: true
                source: window.iconOf(header.section)
            }

            Text {
                anchors {
                    left: icon.right
                    leftMargin: LauncherStyle.contentInset
                    verticalCenter: parent.verticalCenter
                }

                text: header.section
                color: Colors.muted
                font.family: Fonts.family
                font.pixelSize: Fonts.size
            }
        }

        delegate: Rectangle {
            id: row

            required property var modelData
            required property int index

            width: ListView.view.width
            height: LauncherStyle.rowHeight
            color: row.ListView.isCurrentItem ? Colors.hoverOverlay : "transparent"

            // Indented under the app name in the header.
            Text {
                anchors {
                    left: parent.left
                    leftMargin: LauncherStyle.listIndent
                    right: parent.right
                    rightMargin: LauncherStyle.contentInset
                    verticalCenter: parent.verticalCenter
                }

                text: row.modelData.toplevel.title
                color: row.ListView.isCurrentItem ? Colors.accent : Colors.foregroundSoft
                elide: Text.ElideRight
                font.family: Fonts.family
                font.pixelSize: Fonts.size
            }

            MouseArea {
                anchors.fill: parent
                onClicked: window.jumpTo(row.modelData.toplevel)
            }
        }
    }

    // Keys the search field hands over before typing: they drive the list.
    Item {
        id: searchKeys

        Keys.onPressed: event => keys.handle(event)
    }

    SearchField {
        id: footer

        anchors {
            left: parent.left
            bottom: parent.bottom
        }

        width: LauncherStyle.listWidth
        height: LauncherStyle.rowHeight
        focus: true
        keyTargets: [searchKeys]
    }

    Rectangle {
        id: divider

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: list.right
            leftMargin: LauncherStyle.padding
        }

        width: 1
        color: Colors.divider
    }

    WindowPreview {
        id: preview

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: divider.right
            right: parent.right
            leftMargin: LauncherStyle.padding
        }

        toplevel: window.current
        active: window.visible
    }
}
