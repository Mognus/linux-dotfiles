.pragma library

function ready(node) {
    return node !== null && node.ready && node.audio !== null;
}

function volumeRatio(node) {
    return ready(node) ? Math.max(0, Math.min(1, node.audio.volume)) : 0;
}

function percent(node) {
    return Math.round(volumeRatio(node) * 100);
}

function muted(node) {
    return ready(node) && node.audio.muted;
}
