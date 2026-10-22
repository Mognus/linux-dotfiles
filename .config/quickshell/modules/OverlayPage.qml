import QtQuick

// Page content and its presentation needs; the shared overlay owns the frame.
FocusScope {
    required property string title
    property string settingsTitle: title
    property int panelWidth: 600
    property int contentHeight: 340
    property int padding: 12
    property string extraHint: ""
    required property var keyBindings

    focus: true
}
