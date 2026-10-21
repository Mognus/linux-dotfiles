import QtQuick
import qs.services
import "../lib/Navigation.js" as Navigation

// Page content and its presentation needs; the shared overlay owns the frame.
FocusScope {
    required property string title
    property string settingsTitle: title
    property int panelWidth: 600
    property int contentHeight: 340
    property int padding: 12
    property bool searchEnabled: false
    property bool searchAlwaysActive: false
    property bool searching: searchAlwaysActive
    property bool gridNavigation: false
    property string navigationHint: ""
    property string confirmKeys: "ENTER"
    property string confirmLabel: ""
    property string extraHint: ""
    property var keyBindings: null

    focus: true

    function activate() {
        forceActiveFocus();
    }

    // Search fields and controls handle their own keys before they reach here.
    Keys.onPressed: event => {
        if (Navigation.isBack(event)) {
            ShellState.backOverlay();
            event.accepted = true;
        }
    }
}
