import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import QtQuick
import Quickshell.Io
import QtQuick.Layouts

Rectangle {
    id: barBackground
    anchors.fill: parent
    color: activePalette.dark
    // color: "transparent"

    // Integrated look: Flat top, rounded bottom
    // topLeftRadius: 0
    // topRightRadius: 0
    // bottomLeftRadius: 15
    // bottomRightRadius: 15

    // Optional: Subtle border for depth
    // border.color: Qt.rgba(1, 1, 1, 0.1)
    // border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: 6
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        Item {}

        Image {
            source: "file:///home/fiammetta/Pictures/arch.png" // Your custom image
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            sourceSize.width: 40 // Render at 2x size then scale down
            sourceSize.height: 40
            fillMode: Image.PreserveAspectFit

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Hyprland.dispatch("exec rofi -show drun -theme ~/.config/hypr/rofi/launcher.rasi");
                    // You can toggle a dashboard here later
                }
            }
        }

        Item {
            width: 6
        }

        Row {
            Layout.alignment: Qt.AlignLeft
            Row {
                spacing: 8

                Repeater {
                    model: SystemTray.items

                    delegate: Image {
                        required property SystemTrayItem modelData

                        source: modelData.icon // Use the icon provided by the app
                        width: 20
                        height: 20
                        smooth: true

                        mipmap: true
                        sourceSize.width: 40 // Render at 2x size then scale down
                        sourceSize.height: 40
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: mouse => {
                                if (mouse.button === Qt.LeftButton) {
                                    modelData.activate();
                                } else if (mouse.button === Qt.RightButton) {
                                    // We map the click to the root window coordinates
                                    var coords = mapToItem(root.contentItem, mouse.x, mouse.y);
                                    modelData.display(root, coords.x, coords.y);
                                }
                            }
                        }
                    }
                }
            }
        }

        Item {
            Layout.minimumWidth: 12
        }

        Spotify {}

        Item {
            Layout.fillWidth: true
        }
        StatPill {
            id: cpuPill
            icon: ""
            label: "0%"

            Process {
                id: cpuProc
                command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2}'"]

                stdout: StdioCollector {
                    onStreamFinished: {
                        let val = this.text.trim();
                        if (val) {
                            cpuPill.label = Math.round(parseFloat(val)) + "%";
                        }
                    }
                }
            }
            Timer {
                interval: 3000
                running: true
                repeat: true
                onTriggered: {
                    if (cpuProc.running)
                        cpuProc.running = false;
                    cpuProc.running = true;
                }
            }
        }
        StatPill {
            id: ramPill
            icon: ""
            label: "0%"

            Process {
                id: ramProc
                // This command calculates: (used / total) * 100
                command: ["sh", "-c", "free | grep Mem | awk '{print $3/$2 * 100.0}'"]

                stdout: StdioCollector {
                    onStreamFinished: {
                        let val = this.text.trim();
                        // Defensive check to prevent NaN%
                        if (val && !isNaN(parseFloat(val))) {
                            ramPill.label = Math.round(parseFloat(val)) + "%";
                        }
                    }
                }
            }

            // Refresh every 5 seconds
            Timer {
                interval: 5000
                running: true
                repeat: true
                onTriggered: {
                    if (ramProc.running)
                        ramProc.running = false;
                    ramProc.running = true;
                }
            }
        }

        AudioPill {}

        BluetoothPill {}

        StatPill {
            icon: ""
            label: Qt.formatDateTime(clock.date, "hh:mm")
        }
    }

    Row {
        spacing: 20 // <--- ADJUST THIS to change distance between dots
        Layout.alignment: Qt.AlignCenter
        anchors.centerIn: parent // This is the magic line
        Repeater {
            model: 8
            Text {
                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                text: ws ? "" : ""
                color: isActive ? activePalette.highlight : activePalette.text
                font {
                    pixelSize: 14
                    bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                }
            }
        }
    }
}
