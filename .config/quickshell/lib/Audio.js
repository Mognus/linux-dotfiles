.pragma library

function ready(node) {
    return node !== null && node.ready && node.audio !== null;
}

function label(node) {
    if (node === null) {
        return "No device";
    }

    return node.nickname || node.description || node.name;
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

function setVolume(node, ratio) {
    if (!ready(node)) {
        return;
    }

    node.audio.volume = Math.max(0, Math.min(1, ratio));
}

function toggleMute(node) {
    if (ready(node)) {
        node.audio.muted = !node.audio.muted;
    }
}
