import QtQuick
import QtQuick.Layouts
import Quickshell

Scope {
    id: root
    property bool shouldShowOsd: false

    Connections {
        target: Brightness
        function onBrightnessChanged() {
            root.shouldShowOsd = Brightness.first ? false : true;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.shouldShowOsd = false
    }

    LazyLoader {
        active: root.shouldShowOsd ^ root.first

        PanelWindow {
            anchors.right: true
            exclusiveZone: 0
            color: "transparent"

            implicitWidth: 50
            implicitHeight: 250

            margins.right: root.shouldShowOsd ? 0 : -50

            Behavior on margins.right {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutQuint
                }
            }

            Rectangle {
                anchors.fill: parent
                color: Config.mantle

                topLeftRadius: 12
                bottomLeftRadius: 12
                topRightRadius: 0
                bottomRightRadius: 0

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 12

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Brightness.brightness + "%"
                        color: "white"
                        font.pixelSize: 10
                        font.bold: true
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignHCenter
                        implicitWidth: 8
                        radius: 4
                        color: Qt.rgba(1, 1, 1, 0.1)

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: parent.height * (Brightness.brightness / 100)
                            radius: parent.radius
                            color: Config.accent
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: ""
                        color: Config.accent
                        font.pixelSize: 16
                    }
                }
            }
        }
    }
}
