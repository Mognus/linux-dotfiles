import QtQuick

// One row of a Launcher. Opening the row replaces the list with `page`.
QtObject {
    property string title: ""
    property Component page: null
}
