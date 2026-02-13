import Quickshell
import Quickshell.Wayland
import Quickshell.Bluetooth
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import QtQuick.Layouts

PanelWindow {
    id: btMenu
    visible: btMenuOpen

    // Anchor to the top-right
    anchors.top: true
    anchors.right: true

    // Increase margins so it doesn't touch the screen edge
    margins.top: 60
    margins.right: 20

    // Set a fixed width and let height be dynamic
    implicitWidth: 280
    // Use contentItem's childrenRect to ensure it doesn't clip
    implicitHeight: menuLayout.implicitHeight + 40

    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: activePalette.dark
        radius: 12
        border.color: Qt.rgba(1, 1, 1, 0.1)

        ColumnLayout {
            id: menuLayout
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                text: "Bluetooth Settings"
                color: "white"
                font.bold: true
                font.pixelSize: 18
            }

            // The Repeater needs a Layout.fillWidth to stay visible
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                // Add this inside your ColumnLayout, above the Repeater
                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: "Discovery"
                        color: "white"
                        Layout.fillWidth: true
                    }

                    // Simple toggle using the adapter's discovery property
                    Switch { // Or a custom Rectangle-based toggle
                        checked: Bluetooth.defaultAdapter?.discovering
                        onToggled: Bluetooth.defaultAdapter.discovering = !Bluetooth.defaultAdapter.discovering
                    }
                }

                Repeater {
                    model: Bluetooth.devices
                    delegate: Rectangle {
                        implicitHeight: 45
                        Layout.fillWidth: true
                        color: "transparent"
                        Layout.alignment: Qt.AlignVCenter

                        // Visual feedback: Highlight when connected
                        Rectangle {
                            anchors.fill: parent
                            color: modelData.connected ? Qt.rgba(1, 1, 1, 0.05) : "transparent"
                            radius: 4
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 12

                            Text {
                                text: modelData.connected ? "󰂱" : "󰂯"
                                color: modelData.connected ? activePalette.highlight : "gray"
                                font.family: "Symbols Nerd Font"
                            }

                            ColumnLayout {
                                spacing: 2
                                Text {
                                    text: modelData.name || "Unknown Device"
                                    color: "white"
                                    font.pixelSize: 13
                                }
                                Text {
                                    // Show connection status
                                    text: modelData.connected ? "Connected" : (modelData.paired ? "Paired" : "Available")
                                    color: "gray"
                                    font.pixelSize: 10
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                            } // Spacer
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: {
                                if (modelData.connected) {
                                    console.log("Disconnecting from " + modelData.name);
                                    modelData.disconnect(); // Native disconnect call
                                } else {
                                    console.log("Connecting to " + modelData.name);
                                    modelData.connect(); // Native connect call
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
