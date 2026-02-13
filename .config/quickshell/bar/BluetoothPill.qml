import Quickshell
import Quickshell.Bluetooth
import QtQuick

StatPill {
    id: bluetoothPill
    // Native state tracking
    icon: Bluetooth.defaultAdapter?.enabled ? "󰂯" : "󰂲"
    label: Bluetooth.defaultAdapter?.enabled ? "On" : "Off"
    iconColor: Bluetooth.defaultAdapter?.enabled ? activePalette.highlight : "#f38ba8"

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                btMenuOpen = !btMenuOpen; // Toggle Menu
            } else if (mouse.button === Qt.RightButton) {
                Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled; // Toggle
            }
        }
    }
}
