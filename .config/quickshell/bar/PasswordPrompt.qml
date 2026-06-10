import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

PanelWindow {
    id: passwordModal
    visible: root.wifiNetworkToConnect !== null

    // By not anchoring to any edge, it centers on the screen
    anchors.top: false
    anchors.bottom: false
    anchors.left: false
    anchors.right: false

    implicitWidth: 340
    implicitHeight: 180

    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: Config.mantle
        radius: 12
        border.color: Config.accent
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text {
                text: "Connect to WiFi"
                color: Config.text
                font.bold: true
                font.pixelSize: 16
            }

            Text {
                text: root.wifiNetworkToConnect ? "Enter password for: " + root.wifiNetworkToConnect.name : ""
                color: Config.subtext
                font.pixelSize: 12
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            TextField {
                id: passInput
                placeholderText: "Password..."
                echoMode: TextInput.Password
                color: Config.text
                Layout.fillWidth: true
                focus: passwordModal.visible

                background: Rectangle {
                    color: Config.crust
                    radius: 6
                    border.color: passInput.activeFocus ? Config.accent : Qt.rgba(255, 255, 255, 0.1)
                }

                // Press Enter to connect
                onAccepted: {
                    connectAction();
                }
            }

            RowLayout {
                spacing: 12
                Layout.alignment: Qt.AlignRight

                Button {
                    text: "Cancel"
                    onClicked: {
                        cancelAction();
                    }
                }

                Button {
                    id: connectBtn
                    text: "Connect"
                    onClicked: {
                        connectAction();
                    }
                }
            }
        }
    }

    function connectAction() {
        if (root.wifiNetworkToConnect && passInput.text.length > 0) {
            console.log("Connecting to network " + root.wifiNetworkToConnect.name + " with password.");
            root.wifiNetworkToConnect.connectWithPsk(passInput.text);
        }
        root.wifiNetworkToConnect = null;
        passInput.text = "";
    }

    function cancelAction() {
        root.wifiNetworkToConnect = null;
        passInput.text = "";
    }
}
