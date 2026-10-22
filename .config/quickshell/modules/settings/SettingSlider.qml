import QtQuick
import QtQuick.Controls
import qs

// Dragging previews the value locally; releasing commits it once.
FocusScope {
    id: control

    property string title: ""
    property string unit: ""
    property alias from: slider.from
    property alias to: slider.to
    property alias stepSize: slider.stepSize
    property real value: 0
    property Item keyTarget: null
    signal committed(real value)

    implicitHeight: 60
    activeFocusOnTab: true

    Text {
        anchors.left: parent.left
        anchors.top: parent.top
        text: control.title
        color: control.activeFocus ? Colors.accent : Colors.foreground
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

        property real dragValue: 0

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 28
        focus: true
        Keys.forwardTo: control.keyTarget ? [control.keyTarget] : []
        wheelEnabled: true
        snapMode: Slider.SnapAlways
        onPressedChanged: {
            if (pressed) dragValue = value;
            else control.committed(dragValue);
        }
        onMoved: {
            dragValue = value;
            if (!pressed) control.committed(value);
        }

        Binding {
            target: slider
            property: "value"
            value: control.value
            when: !slider.pressed
            restoreMode: Binding.RestoreNone
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
