//@ pragma UseQApplication
// pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Bluetooth
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import Quickshell.Services.Notifications
import QtQuick
import Quickshell.Io
import QtQuick.Layouts

Scope {
    property bool btMenuOpen: false
    PanelWindow {
        id: root
        anchors.top: true
        anchors.left: true
        anchors.right: true
        implicitHeight: 47
        exclusiveZone: 47

        SystemClock {
            id: clock

            precision: SystemClock.Seconds
        }

        Component.onCompleted: {
            Qt.styleHints.useHoverEffects = true;
        }

        SystemPalette {
            id: activePalette

            colorGroup: SystemPalette.Active
        }

        color: "transparent"

        Bar {}
    }

    PanelWindow {
        id: notifAnchor

        // Positioning it below the bar on the right
        anchors.top: true
        anchors.right: true
        margins.top: 50
        margins.right: 15

        // This window is invisible (0 height) until an item is added
        implicitWidth: 350
        implicitHeight: notifColumn.implicitHeight
        color: "transparent"
        exclusiveZone: 0 // Don't push other windows around

        ColumnLayout {
            id: notifColumn
            width: parent.width
            spacing: 10
            // Notifications are spawned here
        }

        NotificationServer {
            id: server
            onNotification: notif => {
                notif.tracked = true;
                const component = Qt.createComponent("Notifs.qml");

                if (component.status === Component.Ready) {
                    component.createObject(notifColumn, {
                        "modelData": notif
                    });
                }
            }
        }
    }
    BluetoothMenu {}

    VolumeOSD {}
}
