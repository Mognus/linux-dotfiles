import QtQuick
import QtQuick.Window
import qs.services
import qs.modules.keyboard

// Page content and its presentation needs; the shared overlay owns the frame.
FocusScope {
    id: page
    required property string title
    property string settingsTitle: title
    property int panelWidth: 600
    property int contentHeight: 340
    property int padding: 12
    property string extraHint: ""
    property var keyBindings: backKeys
    readonly property var controlKeyBindings: {
        const bindings = page.Window.window?.activeFocusItem?.keyBindings ?? null;
        return bindings !== page.keyBindings ? bindings : null;
    }

    focus: true

    function activate() {
        forceActiveFocus();
    }

    KeyBindings {
        id: backKeys
        actions: [
            { keys: [Qt.Key_Escape, Qt.Key_Left, Qt.Key_H], label: ShellState.overlayFromSettings ? "BACK" : "CLOSE", run: () => ShellState.backOverlay() }
        ]
    }

    // Focused controls handle their own keys before unhandled events bubble here.
    Keys.onPressed: event => page.keyBindings.handle(event)
}
