import QtQuick
import QtQuick.Controls
import qs

// Dragging previews the value locally; releasing commits it once.
Item {
    id: control

    property string title: ""
    property string unit: ""
    property alias from: slider.from
    property alias to: slider.to
    property alias stepSize: slider.stepSize
    property alias value: slider.value
    signal committed(real value)

    implicitHeight: 60

    Text {
        anchors.left: parent.left
        anchors.top: parent.top
        text: control.title
        color: Colors.foreground
        font.family: Fonts.family
        font.pixelSize: Fonts.size
    }

    Text {
        anchors.right: parent.right
        anchors.top: parent.top
        text: Math.round(slider.value * 10) / 10 + " " + control.unit
        color: Colors.foregroundSoft
        font.family: Fonts.family
        font.pixelSize: Fonts.size
    }

    Slider {
        id: slider

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 28
        wheelEnabled: true
        snapMode: Slider.SnapAlways
        onPressedChanged: {
            if (!pressed) control.committed(value);
        }
        onMoved: {
            if (!pressed) control.committed(value);
        }

        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + (slider.availableHeight - height) / 2
            width: slider.availableWidth
            height: 8
            color: Colors.subtle

            Rectangle {
                width: parent.width * slider.visualPosition
                height: parent.height
                color: Colors.foreground
            }
        }

        handle: Rectangle {
            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + (slider.availableHeight - height) / 2
            width: 8
            height: 20
            color: Colors.foreground
            border.width: 1
            border.color: slider.activeFocus ? Colors.accent : Colors.background
        }
    }
}
