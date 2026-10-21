import QtQuick

// Local action definitions drive both event handling and the visible hints.
QtObject {
    id: bindings

    property var actions: []
    readonly property string hints: {
        const groups = [];
        for (const action of bindings.actions) {
            if (action.enabled === false || !action.label) continue;
            let group = groups.find(item => item.label === action.label);
            if (!group) {
                group = { label: action.label, keys: [] };
                groups.push(group);
            }
            for (const key of action.keys) {
                const name = bindings.keyName(key, action.modifiers ?? Qt.NoModifier);
                if (!group.keys.includes(name)) group.keys.push(name);
            }
        }
        return groups.map(group => group.keys.join(" / ") + "  " + group.label).join("    ");
    }

    function handle(event) {
        for (const action of bindings.actions) {
            if (action.enabled === false) continue;
            if (action.keys.includes(event.key) && event.modifiers === (action.modifiers ?? Qt.NoModifier)) {
                action.run();
                event.accepted = true;
                return;
            }
        }
    }

    function keyName(key, modifiers) {
        const names = {};
        names[Qt.Key_Up] = "↑";
        names[Qt.Key_Down] = "↓";
        names[Qt.Key_Left] = "←";
        names[Qt.Key_Right] = "→";
        names[Qt.Key_Return] = "ENTER";
        names[Qt.Key_Enter] = "ENTER";
        names[Qt.Key_Escape] = "ESC";
        names[Qt.Key_Delete] = "DEL";
        names[Qt.Key_Space] = "SPACE";
        names[Qt.Key_Tab] = "TAB";
        return ((modifiers & Qt.ControlModifier) ? "CTRL+" : "")
            + ((modifiers & Qt.ShiftModifier) ? "SHIFT+" : "")
            + ((modifiers & Qt.AltModifier) ? "ALT+" : "")
            + ((modifiers & Qt.MetaModifier) ? "SUPER+" : "")
            + (names[key] || String.fromCharCode(key));
    }
}
