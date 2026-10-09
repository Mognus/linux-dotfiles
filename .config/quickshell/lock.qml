import Quickshell
import Quickshell.Io
import Quickshell.Services.Pam
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import qs

// Lock screen as its own process, so a bug or hot reload in the shell can not
// take the lock down. Started with `qs -n -p ~/.config/quickshell/lock.qml`:
// it locks right away and quits after the right password.
ShellRoot {
    id: root

    property string wallpaper: ""

    // ": DP-3: 1920x1080, scale: 1, currently displaying: image: /x/lynx.jpg" → "/x/lynx.jpg"
    Process {
        command: ["awww", "query"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.wallpaper = text.split("image: ")[1]?.split("\n")[0] ?? ""
        }
    }

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    WlSessionLock {
        id: lock

        locked: true

        WlSessionLockSurface {
            id: surface

            color: Colors.background

            // Without a wallpaper the plain background color stays.
            Image {
                id: wallpaper

                anchors.fill: parent
                source: root.wallpaper === "" ? "" : "file://" + root.wallpaper
                fillMode: Image.PreserveAspectCrop
                visible: false
            }

            MultiEffect {
                anchors.fill: parent
                source: wallpaper
                blurEnabled: true
                blur: 1
                blurMax: 64
            }

            Rectangle {
                anchors.fill: parent
                color: Colors.background
                opacity: 0.45
            }

            Column {
                anchors.centerIn: parent
                spacing: 12

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatDateTime(clock.date, "hh:mm")
                    color: Colors.foreground
                    font.family: "Syne, MesloLGS Nerd Font, monospace"
                    font.pixelSize: 96
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatDateTime(clock.date, "dddd, d. MMMM")
                    color: Colors.muted
                    font.family: "Syne, MesloLGS Nerd Font, monospace"
                    font.pixelSize: 18
                }

                Item {
                    width: 1
                    height: 24
                }

                Rectangle {
                    id: field

                    property bool failed: false

                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 280
                    height: 44
                    color: Colors.withAlpha(Colors.surface, 0.6)
                    border.width: 1
                    border.color: {
                        if (field.failed)
                            return Colors.danger;
                        if (input.text !== "")
                            return Colors.accent;
                        return Colors.borderMuted;
                    }

                    TextInput {
                        id: input

                        anchors.fill: parent
                        anchors.margins: 12
                        focus: true
                        readOnly: pam.active
                        echoMode: TextInput.Password
                        passwordCharacter: "•"
                        horizontalAlignment: TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        color: Colors.foreground
                        font.family: "Syne, MesloLGS Nerd Font, monospace"
                        font.pixelSize: 16

                        onTextChanged: field.failed = false
                        onAccepted: {
                            if (input.text !== "" && !pam.active)
                                pam.start();
                        }
                        Keys.onEscapePressed: input.clear()
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: input.text === ""
                        text: field.failed ? "Falsch" : "Passwort"
                        color: field.failed ? Colors.danger : Colors.muted
                        font.family: "Syne, MesloLGS Nerd Font, monospace"
                        font.pixelSize: 16
                    }
                }
            }

            // The pointer has no use on the lock screen.
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.BlankCursor
            }

            // /etc/pam.d/quickshell-lock comes from security.pam.services in the NixOS config.
            PamContext {
                id: pam

                config: "quickshell-lock"

                onPamMessage: {
                    if (pam.responseRequired)
                        pam.respond(input.text);
                }
                onCompleted: result => {
                    if (result === PamResult.Success) {
                        lock.locked = false;
                        Qt.quit();
                        return;
                    }
                    input.clear();
                    field.failed = true;
                }
            }
        }
    }
}
