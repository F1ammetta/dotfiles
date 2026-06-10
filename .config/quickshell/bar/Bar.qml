import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import Quickshell.Services.UPower
import Quickshell.Networking
import QtQuick
import Quickshell.Io
import QtQuick.Layouts

Rectangle {
    id: barBackground
    anchors.fill: parent
    color: Config.glassBg

    RowLayout {
        anchors.fill: parent
        anchors.margins: 6
        anchors.leftMargin: 12
        anchors.rightMargin: 12

        // Left Side Group
        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: 12

            Image {
                source: "file:///home/fiammetta/Pictures/arch.png"
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                sourceSize.width: 40
                sourceSize.height: 40
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.toggleLauncher();
                    }
                }
            }

            // System Tray
            Row {
                spacing: 8

                Repeater {
                    model: SystemTray.items
                    delegate: Image {
                        required property SystemTrayItem modelData

                        source: modelData.icon
                        width: 20
                        height: 20
                        smooth: true
                        mipmap: true
                        sourceSize.width: 40
                        sourceSize.height: 40
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: mouse => {
                                if (mouse.button === Qt.LeftButton) {
                                    modelData.activate();
                                } else if (mouse.button === Qt.RightButton) {
                                    var coords = mapToItem(root.contentItem, mouse.x, mouse.y);
                                    modelData.display(root, coords.x, coords.y);
                                }
                            }
                        }
                    }
                }
            }

            // MPRIS Media Ticker
            Rectangle {
                id: mediaTicker
                height: 26
                radius: 6
                color: activePlayer && activePlayer.isPlaying ? Qt.rgba(203, 166, 247, 0.15) : "transparent"
                border.color: activePlayer && activePlayer.isPlaying ? Config.accent : "transparent"
                border.width: 1
                visible: activePlayer !== null
                implicitWidth: activePlayer ? Math.min(tickerLayout.implicitWidth + 16, 200) : 0

                // 1. New property to act as our memory
                property var lastPlayingPlayer: null

                property var activePlayer: {
                    let players = Mpris.players.values;
                    if (!players || players.length === 0)
                        return null;

                    let supportedPlayers = players.filter(p => {
                        let playerName = (p.identity || p.desktopFile || p.name || "").toLowerCase();
                        return playerName.includes("playerctld") || playerName.includes("spotify") || playerName.includes("feishin");
                    });

                    if (supportedPlayers.length === 0)
                        return null;

                    let activeAndPlaying = supportedPlayers.find(p => p.isPlaying);

                    // 2. Prioritize whatever is currently playing
                    if (activeAndPlaying !== undefined) {
                        return activeAndPlaying;
                    }

                    // 3. If paused, check if our remembered player is still running
                    if (lastPlayingPlayer !== null && supportedPlayers.includes(lastPlayingPlayer)) {
                        return lastPlayingPlayer;
                    }

                    // 4. Absolute fallback (e.g., you just booted up and nothing has played yet)
                    return supportedPlayers[0];
                }

                // 5. Update the memory automatically
                onActivePlayerChanged: {
                    if (activePlayer && activePlayer.isPlaying) {
                        lastPlayingPlayer = activePlayer;
                    }
                }

                RowLayout {
                    id: tickerLayout
                    anchors.fill: parent
                    anchors.margins: 4
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 6

                    Text {
                        text: "󰎆"
                        color: mediaTicker.activePlayer && mediaTicker.activePlayer.isPlaying ? Config.accent : Config.overlay
                        font.pixelSize: 12
                    }

                    Text {
                        text: {
                            if (!mediaTicker.activePlayer)
                                return "";
                            let title = mediaTicker.activePlayer.trackTitle || "Unknown Title";
                            let artist = mediaTicker.activePlayer.trackArtist || "Unknown Artist";
                            return title + " - " + artist;
                        }
                        color: Config.text
                        font.pixelSize: 11
                        font.bold: true
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            mediaTicker.activePlayer.togglePlaying();
                        } else if (mouse.button === Qt.RightButton) {
                            mediaTicker.activePlayer.next();
                        } else if (mouse.button === Qt.MiddleButton) {
                            mediaTicker.activePlayer.previous();
                        }
                    }
                }
            }
        }

        // Spacer
        Item {
            Layout.fillWidth: true
        }

        // Right Side Group: Stats and Dashboard Controls
        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 8

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
                    command: ["sh", "-c", "free | grep Mem | awk '{print $3/$2 * 100.0}'"]
                    stdout: StdioCollector {
                        onStreamFinished: {
                            let val = this.text.trim();
                            if (val && !isNaN(parseFloat(val))) {
                                ramPill.label = Math.round(parseFloat(val)) + "%";
                            }
                        }
                    }
                }
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

            // WiFi / Network Pill
            StatPill {
                id: networkPill
                icon: {
                    let wifiDev = root.wifiDevice;
                    if (wifiDev) {
                        if (!Networking.wifiEnabled)
                            return "󰤭";
                        if (wifiDev.connected) {
                            let connNet = null;
                            for (let i = 0; i < wifiDev.networks.count; i++) {
                                let net = wifiDev.networks.get(i);
                                if (net && net.connected) {
                                    connNet = net;
                                    break;
                                }
                            }
                            let str = connNet ? connNet.signalStrength : 0;
                            if (str >= 0.75)
                                return "󰤨";
                            if (str >= 0.5)
                                return "󰤥";
                            if (str >= 0.25)
                                return "󰤢";
                            return "󰤟";
                        }
                        return "󰤯";
                    }
                    let wiredDev = root.wiredDevice;
                    if (wiredDev && wiredDev.connected)
                        return "";
                    return "󰲜";
                }
                label: {
                    let wifiDev = root.wifiDevice;
                    if (wifiDev && wifiDev.connected) {
                        let connNet = null;
                        for (let i = 0; i < wifiDev.networks.count; i++) {
                            let net = wifiDev.networks.get(i);
                            if (net && net.connected) {
                                connNet = net;
                                break;
                            }
                        }
                        return connNet ? connNet.name : "Connected";
                    }
                    let wiredDev = root.wiredDevice;
                    if (wiredDev && wiredDev.connected)
                        return wiredDev.name || "Wired";
                    return "Disconnected";
                }
                iconColor: label === "Disconnected" ? Config.red : Config.accent

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (root.ccOpen && root.ccActiveTab === "wifi") {
                            root.ccOpen = false;
                        } else {
                            root.ccActiveTab = "wifi";
                            root.ccOpen = true;
                        }
                    }
                }
            }

            // Bluetooth Pill
            BluetoothPill {}

            // Battery Pill
            StatPill {
                id: batteryPill
                visible: UPower.displayDevice && UPower.displayDevice.isPresent
                icon: {
                    let percent = UPower.displayDevice ? UPower.displayDevice.percentage : 0;
                    let state = UPower.displayDevice ? UPower.displayDevice.state : UPowerDeviceState.Unknown;
                    if (state === UPowerDeviceState.Charging) {
                        return "󰂄";
                    }
                    if (percent >= 90)
                        return "󰁹";
                    if (percent >= 80)
                        return "󰂂";
                    if (percent >= 70)
                        return "󰂁";
                    if (percent >= 60)
                        return "󰂀";
                    if (percent >= 50)
                        return "󰁿";
                    if (percent >= 40)
                        return "󰁾";
                    if (percent >= 30)
                        return "󰁽";
                    if (percent >= 20)
                        return "󰁼";
                    if (percent >= 10)
                        return "󰁻";
                    return "󰁺";
                }
                label: Math.round(UPower.displayDevice ? UPower.displayDevice.percentage : 0) + "%"
                iconColor: {
                    let percent = UPower.displayDevice ? UPower.displayDevice.percentage : 0;
                    let state = UPower.displayDevice ? UPower.displayDevice.state : UPowerDeviceState.Unknown;
                    if (state === UPowerDeviceState.Charging)
                        return Config.green;
                    if (percent <= 20)
                        return Config.red;
                    if (percent <= 40)
                        return Config.yellow;
                    return Config.accent;
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.ccOpen = !root.ccOpen;
                    }
                }
            }

            // Audio Pill
            AudioPill {}

            // Clock Pill
            StatPill {
                icon: ""
                label: Qt.formatDateTime(clock.date, "hh:mm")
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.ccOpen = !root.ccOpen;
                    }
                }
            }
        }
    }

    // Center Workspace Indicators
    Row {
        spacing: 20
        Layout.alignment: Qt.AlignCenter
        anchors.centerIn: parent
        Repeater {
            model: 8
            Text {
                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === (index + 1)

                text: ws ? "" : ""
                color: isActive ? Config.accent : Config.text
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
