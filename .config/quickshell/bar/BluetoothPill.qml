import Quickshell
import Quickshell.Bluetooth
import QtQuick

StatPill {
    id: bluetoothPill
    // Native state tracking
    icon: (Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled) ? "󰂯" : "󰂲"
    label: (Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled) ? "On" : "Off"
    iconColor: (Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled) ? Config.accent : Config.red

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                root.ccOpen = !root.ccOpen;
            } else if (mouse.button === Qt.RightButton && Bluetooth.defaultAdapter) {
                Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
            }
        }
    }
}

