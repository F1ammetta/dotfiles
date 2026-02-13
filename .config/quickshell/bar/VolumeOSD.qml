import QtQuick
import QtQuick.Layouts
import Quickshell

Scope {
    id: root
    property bool shouldShowOsd: false

    Connections {
        target: Audio
        function onVolumeChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.shouldShowOsd = false
    }

    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            anchors.right: true
            exclusiveZone: 0 
            color: "transparent"
            
            implicitWidth: 50
            implicitHeight: 250

            // ANIMATION: Slide the window out from the right edge
            // We use the right margin: 0 is visible, negative is hidden.
            margins.right: root.shouldShowOsd ? 0 : -50
            
            Behavior on margins.right {
                NumberAnimation { duration: 300; easing.type: Easing.OutQuint }
            }

            Rectangle {
                anchors.fill: parent
                color: activePalette.dark
                
                // Integrated look: Flat right side, rounded left side
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
                        text: Math.round((Audio.volume || 0) * 100) + "%"
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
                            height: parent.height * (Audio.volume || 0)
                            radius: parent.radius
                            color: Audio.muted ? "#f38ba8" : activePalette.highlight
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Audio.muted ? "" : ""
                        color: Audio.muted ? "#f38ba8" : activePalette.highlight
                        font.pixelSize: 16
                    }
                }
            }
        }
    }
}
