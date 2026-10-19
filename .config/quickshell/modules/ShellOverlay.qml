import Quickshell.Wayland
import QtQuick
import qs.modules.launcher
import qs.modules.settings
import qs.services

// One window, one loaded page, one footer. Routes have at most one parent: Settings.
OverlayWindow {
    id: window

    readonly property var currentPage: page.item
    readonly property var pages: ({
        settings: settingsPage,
        audio: audioPage,
        notifications: notificationsPage,
        session: sessionPage,
        theme: themePage,
        wallpaper: wallpaperPage,
        adjustments: adjustmentsPage,
        launcher: appsPage,
        windowSwitcher: windowsPage,
        clipboard: clipboardPage
    })

    visible: ShellState.overlay !== ""
    title: window.currentPage ? (ShellState.overlayFromSettings ? "SETTINGS / " + window.currentPage.settingsTitle : window.currentPage.title) : ""
    panelWidth: window.currentPage ? window.currentPage.panelWidth : 600
    panelHeight: window.headerHeight + window.dividerHeight + hints.height
        + (window.currentPage ? window.currentPage.contentHeight + window.currentPage.padding * 2 : 0)
    onCloseRequested: ShellState.dismissOverlay()

    // Keep the existing Hyprland blur rule for both entry paths.
    WlrLayershell.namespace: "settings"

    Loader {
        id: page

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: hints.top
        anchors.margins: window.currentPage ? window.currentPage.padding : 0
        active: ShellState.overlay !== ""
        sourceComponent: window.pages[ShellState.overlay] ?? null
        focus: true
        onLoaded: item.activate()
    }

    KeyboardHints {
        id: hints

        searchEnabled: window.currentPage ? window.currentPage.searchEnabled : false
        searching: window.currentPage ? window.currentPage.searching : false
        gridNavigation: window.currentPage ? window.currentPage.gridNavigation : false
        navigationHint: window.currentPage ? window.currentPage.navigationHint : ""
        confirmKeys: window.currentPage ? window.currentPage.confirmKeys : "ENTER"
        confirmLabel: window.currentPage ? window.currentPage.confirmLabel : ""
        extraHint: window.currentPage ? window.currentPage.extraHint : ""
        cancelLabel: window.currentPage && window.currentPage.searching && !window.currentPage.searchAlwaysActive
            ? "CLEAR" : ShellState.overlayFromSettings ? "BACK" : "CLOSE"
    }

    Component { id: settingsPage; SettingsMenu {} }
    Component { id: audioPage; AudioPage {} }
    Component { id: notificationsPage; NotificationsPage {} }
    Component { id: sessionPage; SessionPage {} }
    Component { id: themePage; ThemePage {} }
    Component { id: wallpaperPage; WallpaperPage {} }
    Component { id: adjustmentsPage; AdjustmentsPage {} }
    Component { id: appsPage; AppLauncher {} }
    Component { id: windowsPage; WindowSwitcher {} }
    Component { id: clipboardPage; ClipboardHistory {} }
}
