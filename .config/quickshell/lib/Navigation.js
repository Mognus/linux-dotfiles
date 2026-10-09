.pragma library

// Keys that drive a list while typing goes into a search field: the arrows,
// or Ctrl+hjkl like vim. Plain letters stay free for typing.
// Example: Ctrl+J → isNext(event) is true, plain "j" → false.

function ctrl(event, key) {
    return event.key === key && (event.modifiers & Qt.ControlModifier) !== 0;
}

function isNext(event) {
    return event.key === Qt.Key_Down || ctrl(event, Qt.Key_J);
}

function isPrevious(event) {
    return event.key === Qt.Key_Up || ctrl(event, Qt.Key_K);
}

function isOpen(event) {
    return [Qt.Key_Return, Qt.Key_Enter, Qt.Key_Right].includes(event.key) || ctrl(event, Qt.Key_L);
}

function isBack(event) {
    return [Qt.Key_Escape, Qt.Key_Left].includes(event.key) || ctrl(event, Qt.Key_H);
}
