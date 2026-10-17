.pragma library

// Search fields use arrows or Ctrl+hjkl; plain letters stay available for typing.
// Lists use arrows or plain hjkl. Callers decide what each action does.

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

// List navigation: J → down, while isDown(event) leaves J for search text.
function isListDown(event) {
    return event.key === Qt.Key_Down || event.key === Qt.Key_J;
}

function isListUp(event) {
    return event.key === Qt.Key_Up || event.key === Qt.Key_K;
}

// Return or keypad Enter → confirm a selection.
function isConfirm(event) {
    return event.key === Qt.Key_Return || event.key === Qt.Key_Enter;
}

function isCancel(event) {
    return event.key === Qt.Key_Escape;
}

// Lists also accept Right or L to open the selected entry.
function isOpen(event) {
    return isConfirm(event) || event.key === Qt.Key_Right || event.key === Qt.Key_L;
}

function isBack(event) {
    return isCancel(event) || event.key === Qt.Key_Left || event.key === Qt.Key_H;
}
