.pragma library

// Which direction a key means while typing goes into a search field: the
// arrows, or Ctrl+hjkl like vim. What a direction does is up to the caller.
// Example: Ctrl+J → isDown(event) is true, plain "j" → false.

function ctrl(event, key) {
    return event.key === key && (event.modifiers & Qt.ControlModifier) !== 0;
}

function isUp(event) {
    return event.key === Qt.Key_Up || ctrl(event, Qt.Key_K);
}

function isDown(event) {
    return event.key === Qt.Key_Down || ctrl(event, Qt.Key_J);
}

function isLeft(event) {
    return event.key === Qt.Key_Left || ctrl(event, Qt.Key_H);
}

function isRight(event) {
    return event.key === Qt.Key_Right || ctrl(event, Qt.Key_L);
}
