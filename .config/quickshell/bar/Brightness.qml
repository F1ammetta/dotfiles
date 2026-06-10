pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: brightnessSingleton

    property int brightness: 0
    property bool first: true

    // Initial read on startup via ddcutil
    Process {
        id: initProc
        command: ["sh", "-c", "ddcutil --bus 5 --noverify --skip-ddc-checks getvcp 10 | grep -oP 'current value =\\s+\\K\\d+'"]

        stdout: StdioCollector {
            onStreamFinished: {
                let val = parseInt(this.text.trim());
                if (!isNaN(val)) {
                    brightnessSingleton.brightness = val;
                    if (brightnessSingleton.first)
                        brightnessSingleton.first = false;
                }
            }
        }
    }

    property int pendingBrightness: 0

    // Set brightness via helper script
    Process {
        id: setProc
        // command is set dynamically
    }

    Timer {
        id: applyTimer
        interval: 50 // debounce 50ms
        repeat: false
        onTriggered: {
            if (setProc.running) {
                applyTimer.restart();
                return;
            }
            setProc.command = ["/home/fiammetta/.config/hypr/scripts/brightness", "--set", String(pendingBrightness)];
            setProc.running = true;
        }
    }

    Timer {
        id: userDragCooldown
        interval: 2000 // 2 seconds cooldown
        repeat: false
    }

    function setBrightness(val) {
        let actual = Math.max(0, Math.min(100, val));
        brightnessSingleton.brightness = actual;
        pendingBrightness = actual;
        userDragCooldown.restart();
        applyTimer.restart();
    }

    Component.onCompleted: {
        initProc.running = true;
    }

    // Watch signal file written by ~/.config/hypr/scripts/brightness
    Process {
        id: watchProc
        command: ["cat", "/tmp/brightness"]

        stdout: StdioCollector {
            onStreamFinished: {
                let val = parseInt(this.text.trim());
                if (!isNaN(val) && val !== brightnessSingleton.brightness) {
                    if (!userDragCooldown.running) {
                        brightnessSingleton.brightness = val;
                    }
                }
            }
        }
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            if (watchProc.running)
                watchProc.running = false;
            watchProc.running = true;
        }
    }
}
