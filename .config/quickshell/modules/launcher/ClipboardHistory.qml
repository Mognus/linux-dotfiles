import Quickshell
import Quickshell.Io
import QtQuick
import qs
import qs.modules
import qs.services
import "../../lib/Navigation.js" as Navigation

// Clipboard history from cliphist: the entries on the left, newest first, the
// full text or image of the highlighted one on the right. The search line is
// always active: typing filters, Up/Down or Ctrl+j/k move, Enter copies the
// entry back into the clipboard, Delete removes it, Shift+Delete wipes all.
OverlayPage {
    id: window

    // Parsed `cliphist list` output, refreshed on every opening.
    property var entries: []
    // Entries whose label contains the search: "git" → "git commit -m …".
    readonly property var matches: window.entries.filter(entry => entry.label.toLowerCase().includes(footer.text.toLowerCase()))
    readonly property var current: window.matches[list.currentIndex] ?? null
    // What the right side shows for the current entry: its full text, or the file of its image.
    property string previewText: ""
    property string previewImage: ""
    // Decoded images, cached by entry id because cliphist ids never change; the wipe script clears it.
    readonly property string thumbDir: Quickshell.env("HOME") + "/.cache/cliphist-thumbs"

    // One entry per line of `cliphist list`, which is "<id>\t<preview>":
    // "12\tgit commit" → { line, id: "12", label: "git commit", image: "" },
    // "13\t[[ binary data 32 KiB png 200x120 ]]" → { line, id: "13", label: "png 200x120", image: "png" }.
    function parse(output) {
        const entries = [];
        for (const line of output.split("\n")) {
            const tab = line.indexOf("\t");
            if (tab < 0) {
                continue;
            }
            const preview = line.slice(tab + 1);
            // Browsers copy an HTML companion entry that is never what you want.
            if (preview.startsWith("<meta http-equiv=")) {
                continue;
            }
            const image = preview.match(/^\[\[ binary data .* (png|jpg|jpeg|bmp|webp) (\d+x\d+)/);
            entries.push({
                line: line,
                id: line.slice(0, tab),
                label: image ? image[1] + " " + image[2] : preview,
                image: image ? image[1] : ""
            });
        }
        return entries;
    }

    function copy(entry) {
        // cliphist decode takes the whole list row on stdin, not just the id.
        Quickshell.execDetached(["sh", "-c", 'printf "%s\\n" "$1" | cliphist decode | wl-copy', "sh", entry.line]);
        ShellState.closeClipboard();
    }

    function copyCurrent() {
        if (window.current) {
            window.copy(window.current);
        }
    }

    // Removes the entry and its cached image; the list is read again afterwards.
    function remove(entry) {
        editor.exec(["sh", "-c", 'printf "%s\\n" "$1" | cliphist delete && rm -f "$2/$3".*', "sh", entry.line, window.thumbDir, entry.id]);
    }

    // Empties the whole history and the image cache.
    function wipe() {
        editor.exec(["sh", "-c", 'cliphist wipe && rm -rf "$1"', "sh", window.thumbDir]);
    }

    // Decodes the current entry for the right side: text straight from cliphist,
    // an image into the cache first (via .tmp, so a cut-off decode leaves no half file).
    function loadPreview() {
        window.previewText = "";
        window.previewImage = "";
        const entry = window.current;
        if (!entry) {
            return;
        }
        if (entry.image) {
            const file = window.thumbDir + "/" + entry.id + "." + entry.image;
            imageDecoder.file = file;
            imageDecoder.exec(["sh", "-c", 'mkdir -p "$3" && { [ -s "$2" ] || { printf "%s\\n" "$1" | cliphist decode > "$2.tmp" && mv "$2.tmp" "$2"; }; }', "sh", entry.line, file, window.thumbDir]);
            return;
        }
        textDecoder.exec(["sh", "-c", 'printf "%s\\n" "$1" | cliphist decode', "sh", entry.line]);
    }

    onCurrentChanged: window.loadPreview()

    title: "CLIPBOARD"
    settingsTitle: "Launcher / Clipboard"
    panelWidth: LauncherStyle.listPanelWidth
    contentHeight: LauncherStyle.listPanelHeight - LauncherStyle.padding * 2
    padding: LauncherStyle.padding
    searchEnabled: true
    searchAlwaysActive: true
    confirmLabel: "COPY"
    extraHint: "DEL  DELETE    SHIFT+DEL  WIPE ALL"

    function activate() {
        history.running = true;
        footer.forceActiveFocus();
    }

    Process {
        id: history

        command: ["cliphist", "list"]
        stdout: StdioCollector {
            onStreamFinished: window.entries = window.parse(this.text)
        }
    }

    Process {
        id: editor

        onExited: history.running = true
    }

    Process {
        id: textDecoder

        stdout: StdioCollector {
            // Huge texts would stall the view; the start is enough to recognize them.
            onStreamFinished: window.previewText = this.text.slice(0, 5000)
        }
    }

    Process {
        id: imageDecoder

        property string file: ""

        onExited: exitCode => {
            if (exitCode === 0) {
                window.previewImage = "file://" + imageDecoder.file;
            }
        }
    }

    ListView {
        id: list

        anchors {
            top: parent.top
            left: parent.left
            bottom: footer.top
            bottomMargin: LauncherStyle.padding
        }

        width: LauncherStyle.listWidth
        clip: true
        model: window.matches

        delegate: Rectangle {
            id: row

            required property var modelData
            required property int index

            width: ListView.view.width
            height: LauncherStyle.rowHeight
            color: row.ListView.isCurrentItem ? Colors.hoverOverlay : "transparent"

            Text {
                anchors {
                    left: parent.left
                    leftMargin: LauncherStyle.contentInset
                    right: parent.right
                    rightMargin: LauncherStyle.contentInset
                    verticalCenter: parent.verticalCenter
                }

                text: row.modelData.label
                // Images read as "png 200x120", muted so they stand apart from text.
                color: row.modelData.image ? Colors.muted : row.ListView.isCurrentItem ? Colors.accent : Colors.foregroundSoft
                elide: Text.ElideRight
                font.family: Fonts.family
                font.pixelSize: Fonts.size
            }

            MouseArea {
                anchors.fill: parent
                onClicked: window.copy(row.modelData)
            }
        }
    }

    // Keys the search field hands over before typing: they drive the list.
    Item {
        id: searchKeys

        Keys.onPressed: event => {
            if (Navigation.isDown(event)) {
                list.incrementCurrentIndex();
            } else if (Navigation.isUp(event)) {
                list.decrementCurrentIndex();
            } else if (Navigation.isConfirm(event)) {
                window.copyCurrent();
            } else if (event.key === Qt.Key_Delete && (event.modifiers & Qt.ShiftModifier)) {
                window.wipe();
            } else if (event.key === Qt.Key_Delete) {
                if (window.current) {
                    window.remove(window.current);
                }
            } else if (Navigation.isCancel(event)) {
                ShellState.backOverlay();
            } else {
                return;
            }
            event.accepted = true;
        }
    }

    SearchFooter {
        id: footer

        anchors {
            left: parent.left
            bottom: parent.bottom
        }

        width: LauncherStyle.listWidth
        height: LauncherStyle.rowHeight
        focus: true
        keyTargets: [searchKeys]
    }

    Rectangle {
        id: divider

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: list.right
            leftMargin: LauncherStyle.padding
        }

        width: 1
        color: Colors.divider
    }

    Item {
        id: preview

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: divider.right
            right: parent.right
            leftMargin: LauncherStyle.padding
        }

        Text {
            anchors.fill: parent
            visible: window.previewImage === ""
            text: window.previewText
            // Plain, so copied HTML or markup shows as the characters it is.
            textFormat: Text.PlainText
            wrapMode: Text.WrapAnywhere
            clip: true
            color: Colors.foregroundSoft
            font.family: Fonts.family
            font.pixelSize: Fonts.smallSize
        }

        Image {
            anchors.fill: parent
            visible: window.previewImage !== ""
            source: window.previewImage
            fillMode: Image.PreserveAspectFit
            asynchronous: true
        }
    }
}
