//@ pragma UseQApplication
// pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Bluetooth
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import Quickshell.Services.Notifications
import Quickshell.Networking
import Quickshell.Services.UPower
import Quickshell.Services.Mpris
import QtQuick
import Quickshell.Io
import QtQuick.Layouts

Scope {
    id: root

    // Global UI state management
    property bool ccOpen: false
    property string ccActiveTab: "main"
    property real ccOpenProgress: ccOpen ? 1.0 : 0.0
    Behavior on ccOpenProgress {
        NumberAnimation {
            duration: 350
            easing.type: Easing.OutQuint
        }
    }

    property var wifiNetworkToConnect: null

    property var wifiDevice: null
    property var wiredDevice: null

    property var visible: true

    Instantiator {
        model: Networking.devices
        delegate: QtObject {
            required property var modelData
            Component.onCompleted: {
                if (modelData.type === DeviceType.Wifi) {
                    root.wifiDevice = modelData;
                    modelData.scannerEnabled = true;
                } else if (modelData.type === DeviceType.Wired) {
                    root.wiredDevice = modelData;
                }
            }
            Component.onDestruction: {
                if (root.wifiDevice === modelData) {
                    root.wifiDevice = null;
                }
                if (root.wiredDevice === modelData) {
                    root.wiredDevice = null;
                }
            }
        }
    }

    PanelWindow {
        id: barWindow
        anchors.top: true
        anchors.left: true
        anchors.right: true
        implicitHeight: Config.barHeight
        exclusiveZone: Config.barHeight
        color: "transparent"
        visible: root.visible

        SystemClock {
            id: clock
            precision: SystemClock.Seconds
        }

        Component.onCompleted: {
            Qt.styleHints.useHoverEffects = true;
        }

        Bar {}
    }

    PanelWindow {
        id: notifAnchor

        // Positioning it below the bar on the right
        anchors.top: true
        anchors.right: true
        margins.top: Config.barHeight + Config.borderMargins
        margins.right: Config.borderMargins

        // This window is invisible (0 height) until an item is added
        implicitWidth: Config.notifs.sizes.width
        implicitHeight: notifColumn.implicitHeight
        color: "transparent"
        exclusiveZone: 0 // Don't push other windows around

        ColumnLayout {
            id: notifColumn
            width: parent.width
            spacing: 10
        }

        NotificationServer {
            id: server
            actionsSupported: true
            bodySupported: true
            imageSupported: true
            onNotification: notif => {
                notif.tracked = true;

                // Log to history
                Dnd.addNotification(notif);

                // If DND is enabled, suppress popup banner
                if (Dnd.enabled) {
                    notif.dismiss();
                    return;
                }

                const component = Qt.createComponent("Notifs.qml");
                if (component.status === Component.Ready) {
                    component.createObject(notifColumn, {
                        "modelData": notif
                    });
                }
            }
        }
    }

    // Load Workspace Border overlay (contains the Control Center panel)
    WorkspaceBorder {
        id: borderWinInstance
        // visible: root.visible
    }

    function toggleLauncher() {
        borderWinInstance.launcherOpen = !borderWinInstance.launcherOpen;
        if (borderWinInstance.launcherOpen) {
            root.ccOpen = false;
        }
    }
    function togglevisual() {
        root.visible = !root.visible;
    }
    function togglecc() {
        root.ccOpen = !root.ccOpen;
        if (borderWinInstance.launcherOpen) {
            borderWinInstance.launcherOpen = false;
        }
    }

    GlobalShortcut {
        name: "visible"
        onPressed: root.togglevisual()
    }
    GlobalShortcut {
        name: "launcher"
        onPressed: root.toggleLauncher()
    }
    GlobalShortcut {
        name: "cc"
        onPressed: root.togglecc()
    }

    // Load Wifi Password Modal Dialog overlay
    PasswordPrompt {}

    VolumeOSD {}
    BrightnessOSD {}
    MicMuteOSD {}
}
