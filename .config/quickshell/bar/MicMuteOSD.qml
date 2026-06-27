import QtQuick
import Quickshell

Scope {
    PanelWindow {
        anchors.bottom: true
        anchors.right: true
        margins.bottom: 48
        margins.right: 32
        exclusiveZone: 0
        color: "transparent"

        implicitWidth: 48
        implicitHeight: 48

        visible: Audio.sourceMuted

        Rectangle {
            anchors.fill: parent
            radius: 12
            color: Config.mantle
            border.color: Config.red
            border.width: 2

            Text {
                anchors.centerIn: parent
                text: "󰍭"
                color: Config.red
                font.pixelSize: 22
            }
        }
    }
}
