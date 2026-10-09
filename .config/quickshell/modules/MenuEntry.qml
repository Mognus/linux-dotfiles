import QtQuick

// One row of a Menu. Opening the row replaces the list with `page`; a row
// without a page fires `triggered` instead and the list stays.
QtObject {
    property string title: ""
    property Component page: null

    signal triggered
}
