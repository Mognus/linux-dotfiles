import QtQml

// Local data transformation, independent of focus, selection and presentation.
QtObject {
    id: filter

    property var entries: []
    property string query: ""
    property var textFor: entry => entry.name
    readonly property var matches: {
        const query = filter.query.toLowerCase();
        return Array.from(filter.entries).filter(entry => filter.textFor(entry).toLowerCase().includes(query));
    }
}
