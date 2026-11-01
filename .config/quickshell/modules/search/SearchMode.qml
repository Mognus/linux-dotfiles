import QtQuick

// Owns only the editing mode and focus, never the query or result selection.
QtObject {
    id: mode

    required property Item normalTarget
    required property Item insertTarget
    property bool searching: false

    function activate() {
        if (mode.searching) mode.insertTarget.forceActiveFocus();
        else mode.normalTarget.forceActiveFocus();
    }

    function startSearch() {
        mode.searching = true;
        mode.activate();
    }

    function stopSearch() {
        mode.searching = false;
        mode.activate();
    }
}
