import Quickshell
import Quickshell.Wayland
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Services.Mpris
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Io

PanelWindow {
    id: borderWin

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    exclusiveZone: 0
    color: "transparent"

    // WlrLayershell.keyboardFocus: (root.ccOpen || borderWin.launcherOpen) ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    WlrLayershell.keyboardFocus: (root.ccOpen || borderWin.launcherOpen) ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // Click mask region: Only intercept input when CC or Launcher is open
    // mask: Region {
    //     item: (root.ccOpenProgress > 0.05) ? ccPanel : (borderWin.launcherProgress > 0.05 ? launcherPanel : null)
    // }
    // Click mask region: Trap the whole screen when open to prevent focus loss
    mask: Region {
        item: (root.ccOpen || borderWin.launcherOpen) ? borderWin : null
    }

    // Launcher state and animation
    property bool launcherOpen: false
    property real launcherProgress: launcherOpen ? 1.0 : 0.0
    Behavior on launcherProgress {
        NumberAnimation {
            duration: 350
            easing.type: Easing.OutQuint
        }
    }
    onLauncherProgressChanged: {
        if (launcherProgress > 0.9) {
            launcherSearchInput.forceActiveFocus();
        }
    }
    onLauncherOpenChanged: {
        if (launcherOpen) {
            if (loadAppsProc.running)
                loadAppsProc.running = false;
            loadAppsProc.running = true;
        }
    }

    property var allApps: []
    property var filteredApps: []
    property int launcherSelectedIndex: 0

    function filterApps(query) {
        let q = (query || "").toLowerCase().trim();
        if (!q) {
            filteredApps = allApps;
        } else {
            filteredApps = allApps.filter(app => {
                return app.name.toLowerCase().includes(q) || (app.exec && app.exec.toLowerCase().includes(q));
            });
        }
        launcherSelectedIndex = 0;
    }

    // function launchSelected() {
    //     if (filteredApps.length > 0 && launcherSelectedIndex >= 0 && launcherSelectedIndex < filteredApps.length) {
    //         let app = filteredApps[launcherSelectedIndex];
    //         Hyprland.dispatch("exec " + app.exec);
    //         launcherOpen = false;
    //     }
    // }
    function launchSelected() {
        if (filteredApps.length > 0 && launcherSelectedIndex >= 0 && launcherSelectedIndex < filteredApps.length) {
            let app = filteredApps[launcherSelectedIndex];

            // Asynchronously increment counting database before launch
            let trackingScript = "import os, json; p = os.path.expanduser('~/.cache/launcher_freq.json'); " + "d = json.load(open(p)) if os.path.exists(p) else {}; " + "d['" + app.name + "'] = d.get('" + app.name + "', 0) + 1; " + "json.dump(d, open(p, 'w'))";

            // Fire record processor
            // let updateProc = Qt.createQmlObject('import Quickshell; Process { command: ["python3", "-c", "' + trackingScript + '"] }', borderWin);
            let updateProc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["python3", "-c", "' + trackingScript + '"] }', borderWin);
            updateProc.running = true;

            Hyprland.dispatch("exec " + app.exec);
            launcherOpen = false;
            launcherSearchInput.clear();
        }
    }

    Process {
        id: loadAppsProc
        running: true
        command: ["python3", "-c", '
import os, glob, json

freq_path = os.path.expanduser("~/.cache/launcher_freq.json")
freq_map = {}
if os.path.exists(freq_path):
    try:
        with open(freq_path, "r") as f: freq_map = json.load(f)
    except: pass

# Emulate Rofi / XDG Desktop Menu spec
data_home = os.environ.get("XDG_DATA_HOME", os.path.expanduser("~/.local/share"))
data_dirs = os.environ.get("XDG_DATA_DIRS", "/usr/local/share:/usr/share").split(":")

search_dirs = [os.path.join(data_home, "applications")]
for d in data_dirs:
    if d: search_dirs.append(os.path.join(d, "applications"))

seen_apps = set()
apps = []

for d in search_dirs:
    if not os.path.isdir(d): continue

    # recursive=True catches apps hidden in vendor subfolders
    for path in glob.glob(os.path.join(d, "**/*.desktop"), recursive=True):
        filename = os.path.basename(path)

        # XDG spec: local/earlier directories override system ones for the same filename
        if filename in seen_apps: continue

        try:
            name, exec_cmd, icon, no_display = "", "", "", False
            with open(path, "r", errors="ignore") as f:
                for line in f:
                    if line.startswith("Name=") and not name: name = line.split("=", 1)[1].strip()
                    elif line.startswith("Exec=") and not exec_cmd: exec_cmd = line.split("=", 1)[1].strip()
                    elif line.startswith("Icon=") and not icon: icon = line.split("=", 1)[1].strip()
                    elif line.startswith("NoDisplay=true"): no_display = True

            if name and exec_cmd and not no_display:
                exec_cmd = exec_cmd.split(" %")[0]
                apps.append({"name": name, "exec": exec_cmd, "icon": icon})
                seen_apps.add(filename)
        except: pass

apps.sort(key=lambda x: (-freq_map.get(x["name"], 0), x["name"].lower()))
print(json.dumps(apps))
']
        stdout: StdioCollector {
            onStreamFinished: {
                let text = this.text.trim();
                if (text) {
                    try {
                        borderWin.allApps = JSON.parse(text);
                        borderWin.filterApps(launcherSearchInput.text);
                    } catch (e) {
                        console.log("Error parsing apps:", e);
                    }
                }
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.ccOpen || borderWin.launcherOpen
        onActivated: {
            if (root.ccOpen)
                root.ccOpen = false;
            if (borderWin.launcherOpen) {
                borderWin.launcherOpen = false;
                launcherSearchInput.clear();
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        z: -100 // Stays at the absolute bottom of the window
        enabled: root.ccOpen || borderWin.launcherOpen
        hoverEnabled: true

        onPressed: {
            root.ccOpen = false;
            borderWin.launcherOpen = false;
            launcherSearchInput.clear();
        }
    }

    // Smart background closer: Checks coordinates before closing
    // Main Background Closer

    // Layout constants
    readonly property int margins: Config.borderMargins
    readonly property int barH: Config.barHeight
    readonly property int topMargin: Config.barMargins
    readonly property int y_top: margins
    readonly property int y_bottom: borderWin.height - margins
    readonly property int x_left: margins
    readonly property int x_right: borderWin.width - margins
    readonly property int rounding: Config.borderRounding

    readonly property int ccMaxW: 360
    readonly property int ccMaxH: 620
    readonly property real progress: root.ccOpenProgress

    // Animate dimensions of the CC cutout in the border
    readonly property real ccW: ccMaxW * progress
    readonly property real ccH: ccMaxH * progress
    readonly property real ccX: x_right - ccW
    readonly property real ccY: y_top + ccH

    // Local CPU and RAM stats
    property string cpuUsage: "0%"
    property string ramUsage: "0%"

    Process {
        id: ccCpuProc
        command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                let val = this.text.trim();
                if (val) {
                    borderWin.cpuUsage = Math.round(parseFloat(val)) + "%";
                }
            }
        }
    }
    Timer {
        interval: 3000
        running: borderWin.progress > 0.05
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (ccCpuProc.running)
                ccCpuProc.running = false;
            ccCpuProc.running = true;
        }
    }

    Process {
        id: ccRamProc
        command: ["sh", "-c", "free | grep Mem | awk '{print $3/$2 * 100.0}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                let val = this.text.trim();
                if (val && !isNaN(parseFloat(val))) {
                    borderWin.ramUsage = Math.round(parseFloat(val)) + "%";
                }
            }
        }
    }
    Timer {
        interval: 5000
        running: borderWin.progress > 0.05
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (ccRamProc.running)
                ccRamProc.running = false;
            ccRamProc.running = true;
        }
    }

    // Solid background mask/bezel that frames the workspace area
    Shape {
        anchors.fill: parent
        smooth: true
        antialiasing: true
        // z: 100

        ShapePath {
            // strokeColor: "transparent"
            fillColor: Config.glassBg
            fillRule: ShapePath.OddEvenFill
            strokeColor: (borderWin.progress > 0.01 || borderWin.launcherProgress > 0.01) ? Config.accent : "transparent"

            // Start at outer bottom-left of the bar
            startX: 0
            startY: 0

            // Outer boundary (clockwise)
            PathLine {
                x: borderWin.width
                y: 0 - 10
            }
            PathLine {
                x: borderWin.width + 10
                y: borderWin.height + 10
            }
            PathLine {
                x: 0
                y: borderWin.height
            }
            PathLine {
                x: 0
                y: y_top 
            }

            // Connect to inner path start (top-left of the workspace)
            PathLine {
                x: x_left + rounding
                y: y_top 
            }

            // Connect to inner path start (top-left of the workspace)
            PathLine {
                x: x_left + rounding
                y: y_top
            }

            // ================= TOP EDGE: LAUNCHER CUTOUT =================
            PathLine {
                x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 - Config.launcherWidth / 2 - rounding) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
                y: y_top
            }

            PathQuad {
                x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 - Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
                y: borderWin.launcherProgress > 0.01 ? (y_top + rounding) : y_top
                controlX: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 - Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
                controlY: y_top
            }

            PathLine {
                x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 - Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
                y: borderWin.launcherProgress > 0.01 ? (y_top + Config.launcherHeight * borderWin.launcherProgress - rounding) : y_top
            }

            PathQuad {
                x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 - Config.launcherWidth / 2 + rounding) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
                y: borderWin.launcherProgress > 0.01 ? (y_top + Config.launcherHeight * borderWin.launcherProgress) : y_top
                controlX: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 - Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
                controlY: borderWin.launcherProgress > 0.01 ? (y_top + Config.launcherHeight * borderWin.launcherProgress) : y_top
            }

            PathLine {
                x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 + Config.launcherWidth / 2 - rounding) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
                y: borderWin.launcherProgress > 0.01 ? (y_top + Config.launcherHeight * borderWin.launcherProgress) : y_top
            }

            PathQuad {
                x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 + Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
                y: borderWin.launcherProgress > 0.01 ? (y_top + Config.launcherHeight * borderWin.launcherProgress - rounding) : y_top
                controlX: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 + Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
                controlY: borderWin.launcherProgress > 0.01 ? (y_top + Config.launcherHeight * borderWin.launcherProgress) : y_top
            }

            PathLine {
                x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 + Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
                y: borderWin.launcherProgress > 0.01 ? (y_top + rounding) : y_top
            }

            PathQuad {
                x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 + Config.launcherWidth / 2 + rounding) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
                y: y_top
                controlX: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 + Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
                controlY: y_top
            }

            // ================= TOP EDGE: CONTROL CENTER CUTOUT =================
            PathLine {
                x: borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding)
                y: y_top
            }

            PathQuad {
                x: borderWin.progress > 0.01 ? borderWin.ccX : borderWin.x_right
                y: borderWin.progress > 0.01 ? (y_top + rounding) : (y_top + rounding)
                controlX: borderWin.progress > 0.01 ? borderWin.ccX : borderWin.x_right
                controlY: y_top
            }

            PathLine {
                x: borderWin.progress > 0.01 ? borderWin.ccX : borderWin.x_right
                y: borderWin.progress > 0.01 ? (borderWin.ccY - rounding) : (y_top + rounding)
            }

            PathQuad {
                x: borderWin.progress > 0.01 ? (borderWin.ccX + rounding) : borderWin.x_right
                y: borderWin.progress > 0.01 ? borderWin.ccY : (y_top + rounding)
                controlX: borderWin.progress > 0.01 ? borderWin.ccX : borderWin.x_right
                controlY: borderWin.progress > 0.01 ? borderWin.ccY : (y_top + rounding)
            }

            PathLine {
                x: borderWin.progress > 0.01 ? (borderWin.x_right - rounding) : borderWin.x_right
                y: borderWin.progress > 0.01 ? borderWin.ccY : (y_top + rounding)
            }

            PathQuad {
                x: borderWin.x_right
                y: borderWin.progress > 0.01 ? (borderWin.ccY + rounding) : (y_top + rounding)
                controlX: borderWin.x_right
                controlY: borderWin.progress > 0.01 ? borderWin.ccY : (y_top + rounding)
            }

            // Right vertical edge of screen below CC
            PathLine {
                x: x_right
                y: y_bottom - rounding
            }

            // Bottom-right corner curve
            PathQuad {
                x: x_right - rounding
                y: y_bottom
                controlX: x_right
                controlY: y_bottom
            }

            // ================= BOTTOM EDGE (CLEAN STRAIGHT LINE) =================
            PathLine {
                x: x_left + rounding
                y: y_bottom
            }

            // Bottom-left corner curve
            PathQuad {
                x: x_left
                y: y_bottom - rounding
                controlX: x_left
                controlY: y_bottom
            }

            // Left vertical edge of screen
            PathLine {
                x: x_left
                y: y_top + rounding
            }

            // Top-left corner of the workspace
            PathQuad {
                x: x_left + rounding
                y: y_top
                controlX: x_left
                controlY: y_top
            }

            // Return to start of inner path connection
            PathLine {
                x: x_left + rounding
                y: y_top
            }

            // Go back to the outer left-edge transition point to close properly
            PathLine {
                x: 0
                y: y_top
            }
            PathLine {
                x: 0
                y: barH
            }
        }
    }

    // We use a single path Shape to draw the workspace border
    // It morphs smoothly to wrap around the Control Center dropdown as it opens
    ShapePath {
        strokeWidth: Config.borderThickness
        strokeColor: borderWin.progress > 0.01 ? Config.accent : Qt.rgba(255, 255, 255, 0.12)
        // strokeColor: (borderWin.progress > 0.01 || borderWin.launcherProgress > 0.01) ? Config.accent : Qt.rgba(255, 255, 255, 0.12)
        // strokeColor: Config.accent
        fillColor: "transparent"
        capStyle: ShapePath.RoundCap
        joinStyle: ShapePath.RoundJoin
        // Start at top-left corner of the workspace
        startX: x_left + rounding
        startY: y_top

        // ================= TOP EDGE: LAUNCHER CUTOUT =================
        PathLine {
            x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 - Config.launcherWidth / 2 - rounding) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
            y: y_top
        }

        PathQuad {
            x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 - Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
            y: borderWin.launcherProgress > 0.01 ? (y_top + rounding) : y_top
            controlX: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 - Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
            controlY: y_top
        }

        PathLine {
            x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 - Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
            y: borderWin.launcherProgress > 0.01 ? (y_top + Config.launcherHeight * borderWin.launcherProgress - rounding) : y_top
        }

        PathQuad {
            x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 - Config.launcherWidth / 2 + rounding) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
            y: borderWin.launcherProgress > 0.01 ? (y_top + Config.launcherHeight * borderWin.launcherProgress) : y_top
            controlX: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 - Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
            controlY: borderWin.launcherProgress > 0.01 ? (y_top + Config.launcherHeight * borderWin.launcherProgress) : y_top
        }

        PathLine {
            x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 + Config.launcherWidth / 2 - rounding) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
            y: borderWin.launcherProgress > 0.01 ? (y_top + Config.launcherHeight * borderWin.launcherProgress) : y_top
        }

        PathQuad {
            x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 + Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
            y: borderWin.launcherProgress > 0.01 ? (y_top + Config.launcherHeight * borderWin.launcherProgress - rounding) : y_top
            controlX: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 + Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
            controlY: borderWin.launcherProgress > 0.01 ? (y_top + Config.launcherHeight * borderWin.launcherProgress) : y_top
        }

        PathLine {
            x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 + Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
            y: borderWin.launcherProgress > 0.01 ? (y_top + rounding) : y_top
        }

        PathQuad {
            x: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 + Config.launcherWidth / 2 + rounding) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
            y: y_top
            controlX: borderWin.launcherProgress > 0.01 ? (borderWin.width / 2 + Config.launcherWidth / 2) : (borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding))
            controlY: y_top
        }

        // ================= TOP EDGE: CONTROL CENTER CUTOUT =================
        PathLine {
            x: borderWin.progress > 0.01 ? (borderWin.ccX - rounding) : (borderWin.x_right - rounding)
            y: y_top
        }

        PathQuad {
            x: borderWin.progress > 0.01 ? borderWin.ccX : borderWin.x_right
            y: borderWin.progress > 0.01 ? (y_top + rounding) : (y_top + rounding)
            controlX: borderWin.progress > 0.01 ? borderWin.ccX : borderWin.x_right
            controlY: y_top
        }

        PathLine {
            x: borderWin.progress > 0.01 ? borderWin.ccX : borderWin.x_right
            y: borderWin.progress > 0.01 ? (borderWin.ccY - rounding) : (y_top + rounding)
        }

        PathQuad {
            x: borderWin.progress > 0.01 ? (borderWin.ccX + rounding) : borderWin.x_right
            y: borderWin.progress > 0.01 ? (borderWin.ccY) : (y_top + rounding)
            controlX: borderWin.progress > 0.01 ? borderWin.ccX : borderWin.x_right
            controlY: borderWin.progress > 0.01 ? borderWin.ccY : (y_top + rounding)
        }

        PathLine {
            x: borderWin.progress > 0.01 ? (borderWin.x_right - rounding) : borderWin.x_right
            y: borderWin.progress > 0.01 ? (borderWin.ccY) : (y_top + rounding)
        }

        PathQuad {
            x: borderWin.x_right
            y: borderWin.progress > 0.01 ? (borderWin.ccY + rounding) : (y_top + rounding)
            controlX: borderWin.x_right
            controlY: borderWin.progress > 0.01 ? borderWin.ccY : (y_top + rounding)
        }

        // Right vertical edge of screen below CC
        PathLine {
            x: x_right
            y: y_bottom - rounding
        }

        // Bottom-right corner curve
        PathQuad {
            x: x_right - rounding
            y: y_bottom
            controlX: x_right
            controlY: y_bottom
        }

        // ================= BOTTOM EDGE (CLEAN STRAIGHT LINE) =================
        PathLine {
            x: x_left + rounding
            y: y_bottom
        }

        // Bottom-left corner curve
        PathQuad {
            x: x_left
            y: y_bottom - rounding
            controlX: x_left
            controlY: y_bottom
        }

        // Left vertical edge of screen
        PathLine {
            x: x_left
            y: y_top + rounding
        }

        // Top-left corner of the workspace
        PathQuad {
            x: x_left + rounding
            y: y_top
            controlX: x_left
            controlY: y_top
        }
    }

    // hyprsunset Process for Night Light
    Process {
        id: hyprsunsetProc
        command: ["hyprsunset", "-t", "4500"]
    }

    property bool shouldStartHyprsunset: false

    Process {
        id: killProc
        command: ["sh", "-c", "pkill hyprsunset; pkill wlsunset"]
        onRunningChanged: {
            if (!running && borderWin.shouldStartHyprsunset) {
                borderWin.shouldStartHyprsunset = false;
                hyprsunsetProc.running = true;
            }
        }
    }

    // Night Light state helper
    property bool nightLightEnabled: hyprsunsetProc.running || shouldStartHyprsunset

    // Control Center Dropdown Panel
    Rectangle {
        id: ccPanel
        x: borderWin.x_right - borderWin.ccMaxW
        y: borderWin.y_top
        width: borderWin.ccMaxW
        height: borderWin.ccMaxH - 2
        topLeftRadius: 0
        topRightRadius: 0
        bottomLeftRadius: borderWin.rounding
        bottomRightRadius: borderWin.rounding
        color: Config.mantle
        border.color: "transparent"  // <-- FORCE this to transparent
        border.width: 0
        clip: true

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 1
            anchors.rightMargin: 1
            height: 1
            color: Config.mantle
            z: 1
        }

        visible: borderWin.progress > 0.01
        opacity: borderWin.progress
        transform: Translate {
            y: -15 * (1 - borderWin.progress)
        }

        // Local state
        property string activeTab: "main"

        // Reset to main tab when the panel finishes hiding
        onOpacityChanged: {
            if (opacity === 0)
                activeTab = "main";
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // ================= HEADER =================
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: Qt.formatDateTime(clock.date, "dddd, MMMM d")
                    color: Config.text
                    font.bold: true
                    font.pixelSize: 14
                    Layout.fillWidth: true
                }
            }

            // Stack layout for pages
            StackLayout {
                id: ccStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: {
                    if (ccPanel.activeTab === "wifi")
                        return 1;
                    if (ccPanel.activeTab === "bluetooth")
                        return 2;
                    if (ccPanel.activeTab === "mixer")
                        return 3;
                    return 0; // Always safely fallback to Main
                }

                // PAGE 0: MAIN DASHBOARD
                ColumnLayout {
                    spacing: 14

                    // Quick settings toggles grid
                    GridLayout {
                        columns: 2
                        Layout.fillWidth: true
                        rowSpacing: 10
                        columnSpacing: 10

                        // Wifi Toggle Button
                        Rectangle {
                            id: wifiPill
                            Layout.fillWidth: true
                            height: 48
                            radius: 8
                            color: wifiMouseArea.containsMouse ? (Networking.wifiEnabled ? Qt.rgba(203, 166, 247, 0.3) : Qt.rgba(255, 255, 255, 0.08)) : (Networking.wifiEnabled ? Qt.rgba(203, 166, 247, 0.2) : Qt.rgba(255, 255, 255, 0.05))
                            border.color: Networking.wifiEnabled ? Config.accent : "transparent"

                            MouseArea {
                                id: wifiMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: ccPanel.activeTab = "wifi"
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 8

                                Text {
                                    text: Networking.wifiEnabled ? "󰤨" : "󰤭"
                                    color: Networking.wifiEnabled ? Config.accent : Config.overlay
                                    font.pixelSize: 16
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                Column {
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    Text {
                                        text: "Wi-Fi"
                                        color: Config.text
                                        font.bold: true
                                        font.pixelSize: 12
                                    }
                                    Text {
                                        text: {
                                            if (!Networking.wifiEnabled)
                                                return "Disabled";
                                            let wifiDev = root.wifiDevice;
                                            if (wifiDev && wifiDev.connected) {
                                                for (let i = 0; i < wifiDev.networks.count; i++) {
                                                    let net = wifiDev.networks.get(i);
                                                    if (net && net.connected) {
                                                        return net.name || "Connected";
                                                    }
                                                }
                                                return "Connected";
                                            }
                                            return "Disconnected";
                                        }
                                        color: Config.subtext
                                        font.pixelSize: 10
                                        elide: Text.ElideRight
                                    }
                                }

                                Text {
                                    text: "❯"
                                    color: Config.overlay
                                    font.pixelSize: 10
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }
                        }

                        // Bluetooth Toggle Button
                        Rectangle {
                            id: bluetoothPill
                            Layout.fillWidth: true
                            height: 48
                            radius: 8
                            color: btMouseArea.containsMouse ? ((Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled) ? Qt.rgba(137, 180, 250, 0.3) : Qt.rgba(255, 255, 255, 0.08)) : ((Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled) ? Qt.rgba(137, 180, 250, 0.2) : Qt.rgba(255, 255, 255, 0.05))
                            border.color: (Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled) ? Config.blue : "transparent"

                            MouseArea {
                                id: btMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: ccPanel.activeTab = "bluetooth"
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 8

                                Text {
                                    text: (Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled) ? "󰂯" : "󰂲"
                                    color: (Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled) ? Config.blue : Config.overlay
                                    font.pixelSize: 16
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                Column {
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    Text {
                                        text: "Bluetooth"
                                        color: Config.text
                                        font.bold: true
                                        font.pixelSize: 12
                                    }
                                    Text {
                                        text: (Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled) ? "On" : "Off"
                                        color: Config.subtext
                                        font.pixelSize: 10
                                    }
                                }

                                Text {
                                    text: "❯"
                                    color: Config.overlay
                                    font.pixelSize: 10
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }
                        }

                        // DND Button
                        Rectangle {
                            Layout.fillWidth: true
                            height: 48
                            radius: 8
                            color: dndMouseArea.containsMouse ? (Dnd.enabled ? Qt.rgba(166, 227, 161, 0.3) : Qt.rgba(255, 255, 255, 0.08)) : (Dnd.enabled ? Qt.rgba(166, 227, 161, 0.2) : Qt.rgba(255, 255, 255, 0.05))
                            border.color: Dnd.enabled ? Config.green : "transparent"

                            MouseArea {
                                id: dndMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: Dnd.enabled = !Dnd.enabled
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 8

                                Text {
                                    text: Dnd.enabled ? "󰤄" : "󰤅"
                                    color: Dnd.enabled ? Config.green : Config.overlay
                                    font.pixelSize: 16
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                Column {
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    Text {
                                        text: "Do Not Disturb"
                                        color: Config.text
                                        font.bold: true
                                        font.pixelSize: 12
                                    }
                                    Text {
                                        text: Dnd.enabled ? "On" : "Off"
                                        color: Config.subtext
                                        font.pixelSize: 10
                                    }
                                }
                            }
                        }

                        // Night Light Button
                        Rectangle {
                            Layout.fillWidth: true
                            height: 48
                            radius: 8
                            color: nlMouseArea.containsMouse ? (borderWin.nightLightEnabled ? Qt.rgba(249, 226, 175, 0.3) : Qt.rgba(255, 255, 255, 0.08)) : (borderWin.nightLightEnabled ? Qt.rgba(249, 226, 175, 0.2) : Qt.rgba(255, 255, 255, 0.05))
                            border.color: borderWin.nightLightEnabled ? Config.yellow : "transparent"

                            MouseArea {
                                id: nlMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    if (hyprsunsetProc.running) {
                                        hyprsunsetProc.running = false;
                                        borderWin.shouldStartHyprsunset = false;
                                        killProc.running = true;
                                    } else {
                                        borderWin.shouldStartHyprsunset = true;
                                        if (killProc.running) {
                                            // Let it trigger when done
                                        } else {
                                            killProc.running = true;
                                        }
                                    }
                                }
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 8

                                Text {
                                    text: borderWin.nightLightEnabled ? "" : ""
                                    color: borderWin.nightLightEnabled ? Config.yellow : Config.overlay
                                    font.pixelSize: 16
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                Column {
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    Text {
                                        text: "Night Light"
                                        color: Config.text
                                        font.bold: true
                                        font.pixelSize: 12
                                    }
                                    Text {
                                        text: borderWin.nightLightEnabled ? "On" : "Off"
                                        color: Config.subtext
                                        font.pixelSize: 10
                                    }
                                }
                            }
                        }
                    }

                    // System Sliders
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        // Volume Slider
                        RowLayout {
                            spacing: 10
                            Text {
                                text: Audio.muted ? "󰝟" : "󰕾"
                                color: Config.accent
                                font.pixelSize: 16
                                Layout.preferredWidth: 24
                                horizontalAlignment: Text.AlignHCenter
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: Audio.toggleMute()
                                }
                            }
                            Slider {
                                Layout.fillWidth: true
                                value: Audio.volume
                                onMoved: Audio.setVolume(value)
                            }
                            Text {
                                text: ""
                                color: Config.accent
                                font.pixelSize: 14
                                Layout.preferredWidth: 20
                                horizontalAlignment: Text.AlignHCenter
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: ccPanel.activeTab = "mixer"
                                }
                            }
                            Text {
                                text: Audio.muted ? "Mute" : Math.round(Audio.volume * 100) + "%"
                                color: Config.subtext
                                font.pixelSize: 10
                                Layout.preferredWidth: 28
                            }
                        }

                        // Microphone Slider
                        RowLayout {
                            spacing: 10
                            Text {
                                text: Audio.sourceMuted ? "󰍭" : "󰍬"
                                color: Config.accent
                                font.pixelSize: 16
                                Layout.preferredWidth: 24
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Slider {
                                Layout.fillWidth: true
                                value: Audio.sourceVolume
                                onMoved: Audio.setSourceVolume(value)
                            }
                            Text {
                                text: Audio.sourceMuted ? "Mute" : Math.round(Audio.sourceVolume * 100) + "%"
                                color: Config.subtext
                                font.pixelSize: 10
                            }
                        }

                        // Brightness Slider
                        RowLayout {
                            spacing: 10
                            Text {
                                text: ""
                                color: Config.accent
                                font.pixelSize: 16
                                Layout.preferredWidth: 24
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Slider {
                                Layout.fillWidth: true
                                value: Brightness.brightness / 100.0
                                onMoved: Brightness.setBrightness(value * 100)
                            }
                            Text {
                                text: Brightness.brightness + "%"
                                color: Config.subtext
                                font.pixelSize: 10
                            }
                        }
                    }

                    // MPRIS Media Controller
                    Rectangle {
                        id: mediaController
                        Layout.fillWidth: true
                        height: 90
                        radius: 8
                        color: Qt.rgba(255, 255, 255, 0.04)
                        border.color: Qt.rgba(255, 255, 255, 0.08)

                        // 1. Memory property
                        property var lastPlayingPlayer: null

                        // 2. Updated player logic
                        property var mprisPlayer: {
                            let players = Mpris.players.values;
                            if (!players || players.length === 0)
                                return null;

                            let supportedPlayers = players.filter(p => {
                                let id = (p.identity || p.desktopFile || p.name || "").toLowerCase();
                                let dbus = (p.dbusName || "").toLowerCase();

                                return id.includes("playerctld") || id.includes("spotify") || id.includes("feishin") || dbus.includes("playerctld") || dbus.includes("spotify") || dbus.includes("feishin");
                            });

                            if (supportedPlayers.length === 0)
                                return null;

                            let activeAndPlaying = supportedPlayers.find(p => p.isPlaying);

                            if (activeAndPlaying !== undefined) {
                                return activeAndPlaying;
                            }

                            if (lastPlayingPlayer !== null && supportedPlayers.includes(lastPlayingPlayer)) {
                                return lastPlayingPlayer;
                            }

                            return supportedPlayers[0];
                        }

                        // 3. Update memory automatically
                        onMprisPlayerChanged: {
                            if (mprisPlayer && mprisPlayer.isPlaying) {
                                lastPlayingPlayer = mprisPlayer;
                            }
                        }

                        visible: mprisPlayer !== null

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 12

                            // Album art
                            Rectangle {
                                width: 70
                                height: 70
                                radius: 6
                                color: "#11111b"
                                clip: true
                                Image {
                                    anchors.fill: parent
                                    source: (mediaController.mprisPlayer && mediaController.mprisPlayer.trackArtUrl !== undefined) ? mediaController.mprisPlayer.trackArtUrl : ""
                                    fillMode: Image.PreserveAspectCrop
                                    visible: source != ""
                                }
                                Text {
                                    text: "🎵"
                                    anchors.centerIn: parent
                                    visible: !parent.children[0].visible
                                }
                            }

                            // Info and Controls
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: (mediaController.mprisPlayer && mediaController.mprisPlayer.trackTitle !== undefined) ? mediaController.mprisPlayer.trackTitle : "Unknown Track"
                                    color: Config.text
                                    font.bold: true
                                    font.pixelSize: 13
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: (mediaController.mprisPlayer && mediaController.mprisPlayer.trackArtist !== undefined) ? mediaController.mprisPlayer.trackArtist : "Unknown Artist"
                                    color: Config.subtext
                                    font.pixelSize: 11
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                RowLayout {
                                    spacing: 14
                                    Layout.alignment: Qt.AlignHCenter

                                    Text {
                                        text: "⏮"
                                        color: Config.text
                                        font.pixelSize: 14
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: mediaController.mprisPlayer.previous()
                                        }
                                    }

                                    Text {
                                        text: (mediaController.mprisPlayer && mediaController.mprisPlayer.isPlaying) ? "⏸" : "▶"
                                        color: Config.accent
                                        font.pixelSize: 16
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: mediaController.mprisPlayer.togglePlaying()
                                        }
                                    }

                                    Text {
                                        text: "⏭"
                                        color: Config.text
                                        font.pixelSize: 14
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: mediaController.mprisPlayer.next()
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // System Resource and Battery Info
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        // CPU Info
                        Column {
                            Layout.fillWidth: true
                            spacing: 4
                            Text {
                                text: "CPU"
                                color: Config.subtext
                                font.pixelSize: 10
                            }
                            ProgressBar {
                                width: parent.width
                                value: parseFloat(borderWin.cpuUsage) / 100.0
                            }
                            Text {
                                text: borderWin.cpuUsage
                                color: Config.text
                                font.bold: true
                                font.pixelSize: 11
                            }
                        }

                        // RAM Info
                        Column {
                            Layout.fillWidth: true
                            spacing: 4
                            Text {
                                text: "RAM"
                                color: Config.subtext
                                font.pixelSize: 10
                            }
                            ProgressBar {
                                width: parent.width
                                value: parseFloat(borderWin.ramUsage) / 100.0
                            }
                            Text {
                                text: borderWin.ramUsage
                                color: Config.text
                                font.bold: true
                                font.pixelSize: 11
                            }
                        }

                        // Battery Info
                        Column {
                            Layout.fillWidth: true
                            spacing: 4
                            visible: UPower.displayDevice && UPower.displayDevice.isPresent
                            Text {
                                text: "Battery"
                                color: Config.subtext
                                font.pixelSize: 10
                            }
                            ProgressBar {
                                width: parent.width
                                value: (UPower.displayDevice && UPower.displayDevice.percentage !== undefined) ? UPower.displayDevice.percentage / 100.0 : 0
                            }
                            Text {
                                text: Math.round((UPower.displayDevice && UPower.displayDevice.percentage !== undefined) ? UPower.displayDevice.percentage : 0) + "%" + ((UPower.displayDevice && UPower.displayDevice.state === UPowerDeviceState.Charging) ? " ⚡" : "")
                                color: Config.text
                                font.bold: true
                                font.pixelSize: 11
                            }
                        }
                    }

                    // Notifications Center Section
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 8
                        color: Qt.rgba(0, 0, 0, 0.2)
                        border.color: Qt.rgba(255, 255, 255, 0.05)
                        clip: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 6

                            RowLayout {
                                Layout.fillWidth: true
                                Text {
                                    text: "Notification History"
                                    color: Config.text
                                    font.bold: true
                                    font.pixelSize: 11
                                }
                                Item {
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: "Clear All"
                                    color: Config.accent
                                    font.pixelSize: 10
                                    font.bold: true
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: Dnd.clearHistory()
                                    }
                                }
                            }

                            ListView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                model: Dnd.notificationHistory
                                spacing: 4
                                clip: true

                                delegate: Rectangle {
                                    width: ListView.view.width
                                    height: 36
                                    radius: 4
                                    color: Qt.rgba(255, 255, 255, 0.03)

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 6
                                        spacing: 8

                                        Text {
                                            text: modelData.summary
                                            color: Config.text
                                            font.bold: true
                                            font.pixelSize: 11
                                            Layout.preferredWidth: 80
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            text: modelData.body
                                            color: Config.subtext
                                            font.pixelSize: 10
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            text: "✕"
                                            color: Config.red
                                            font.pixelSize: 10
                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: Dnd.removeNotification(modelData.id)
                                            }
                                        }
                                    }
                                }

                                Text {
                                    text: "No notification history"
                                    color: Config.overlay
                                    font.pixelSize: 11
                                    anchors.centerIn: parent
                                    visible: Dnd.notificationHistory.length === 0
                                }
                            }
                        }
                    }
                }

                // PAGE 1: WIFI SELECTION LIST
                ColumnLayout {
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "❮ Back"
                            color: Config.accent
                            font.bold: true
                            MouseArea {
                                anchors.fill: parent
                                onClicked: ccPanel.activeTab = "main"
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "WiFi Settings"
                            color: Config.text
                            font.bold: true
                            font.pixelSize: 14
                        }
                        Rectangle {
                            width: 36
                            height: 20
                            radius: 10
                            color: Networking.wifiEnabled ? Config.accent : Qt.rgba(255, 255, 255, 0.1)

                            Rectangle {
                                width: 16
                                height: 16
                                radius: 8
                                color: "white"
                                x: Networking.wifiEnabled ? 18 : 2
                                anchors.verticalCenter: parent.verticalCenter

                                Behavior on x {
                                    NumberAnimation {
                                        duration: 150
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
                            }
                        }
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 6

                        model: root.wifiDevice ? root.wifiDevice.networks : null

                        delegate: Rectangle {
                            width: ListView.view.width
                            height: 40
                            radius: 6
                            color: modelData.connected ? Qt.rgba(203, 166, 247, 0.15) : (dwifiMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : (modelData.known ? Qt.rgba(255, 255, 255, 0.03) : "transparent"))
                            border.color: modelData.connected ? Config.accent : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 10

                                Text {
                                    text: {
                                        let str = modelData.signalStrength;
                                        if (str >= 0.75)
                                            return "󰤨";
                                        if (str >= 0.5)
                                            return "󰤥";
                                        if (str >= 0.25)
                                            return "󰤢";
                                        return "󰤟";
                                    }
                                    color: modelData.connected ? Config.accent : Config.text
                                    font.pixelSize: 14
                                    Layout.preferredWidth: 24
                                    Layout.alignment: Qt.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                }

                                Text {
                                    text: modelData.name || "Hidden Network"
                                    color: Config.text
                                    font.pixelSize: 12
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: modelData.security !== WifiSecurityType.Open ? "🔒" : ""
                                    color: Config.overlay
                                    font.pixelSize: 10
                                    Layout.alignment: Qt.AlignVCenter
                                    visible: text !== ""
                                }

                                Text {
                                    text: modelData.connected ? "Connected" : (modelData.stateChanging ? "..." : "")
                                    color: Config.accent
                                    font.pixelSize: 10
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: dwifiMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    if (modelData.connected) {
                                        modelData.disconnect();
                                    } else if (modelData.security === WifiSecurityType.Open) {
                                        modelData.connect();
                                    } else {
                                        root.wifiNetworkToConnect = modelData;
                                    }
                                }
                            }
                        }
                    }
                }

                // PAGE 2: BLUETOOTH SELECTION LIST
                ColumnLayout {
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "❮ Back"
                            color: Config.accent
                            font.bold: true
                            MouseArea {
                                anchors.fill: parent
                                onClicked: ccPanel.activeTab = "main"
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "Bluetooth Settings"
                            color: Config.text
                            font.bold: true
                            font.pixelSize: 14
                        }
                        Rectangle {
                            width: 36
                            height: 20
                            radius: 10
                            color: (Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled) ? Config.blue : Qt.rgba(255, 255, 255, 0.1)

                            Rectangle {
                                width: 16
                                height: 16
                                radius: 8
                                color: "white"
                                x: (Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled) ? 18 : 2
                                anchors.verticalCenter: parent.verticalCenter

                                Behavior on x {
                                    NumberAnimation {
                                        duration: 150
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (Bluetooth.defaultAdapter)
                                        Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
                                }
                            }
                        }
                    }

                    ListView {
                        id: btListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 6
                        model: Bluetooth.devices

                        function getBluetoothIcon(iconStr, connected) {
                            if (!iconStr)
                                return connected ? "󰂱" : "󰂯";
                            let lower = iconStr.toLowerCase();
                            if (lower.indexOf("headset") !== -1 || lower.indexOf("headphones") !== -1 || lower.indexOf("audio") !== -1)
                                return "󰋋";
                            if (lower.indexOf("keyboard") !== -1)
                                return "󰌌";
                            if (lower.indexOf("mouse") !== -1 || lower.indexOf("pointing") !== -1)
                                return "󰍽";
                            if (lower.indexOf("phone") !== -1)
                                return "󰏲";
                            if (lower.indexOf("computer") !== -1)
                                return "󰞹";
                            if (lower.indexOf("controller") !== -1 || lower.indexOf("gamepad") !== -1)
                                return "󰖺";
                            return connected ? "󰂱" : "󰂯";
                        }

                        delegate: Rectangle {
                            id: btItem
                            width: ListView.view.width
                            height: 46
                            radius: 8
                            color: modelData.connected ? Qt.rgba(Config.blue.r, Config.blue.g, Config.blue.b, 0.12) : (mouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.05) : "transparent")
                            border.color: modelData.connected ? Config.blue : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                spacing: 12

                                Text {
                                    text: btListView.getBluetoothIcon(modelData.icon, modelData.connected)
                                    color: modelData.connected ? Config.blue : Config.overlay
                                    font.pixelSize: 16
                                    Layout.preferredWidth: 24
                                    Layout.alignment: Qt.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                }

                                ColumnLayout {
                                    spacing: 2
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    Text {
                                        text: modelData.name || "Unknown Device"
                                        color: Config.text
                                        font.pixelSize: 12
                                        font.bold: modelData.connected
                                        font.family: "sans-serif"
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        text: modelData.connected ? "Connected" + (modelData.batteryAvailable ? " (" + Math.round(modelData.battery) + "%)" : "") : (modelData.paired ? "Paired" : "Available")
                                        color: Config.subtext
                                        font.pixelSize: 9
                                        font.family: "sans-serif"
                                    }
                                }

                                // Connect / disconnect action pill
                                Rectangle {
                                    width: 68
                                    height: 22
                                    radius: 11
                                    color: modelData.connected ? Config.red : Config.accent
                                    opacity: mouseArea.containsMouse || modelData.connected ? 1.0 : 0.0
                                    Layout.alignment: Qt.AlignVCenter

                                    Behavior on opacity {
                                        NumberAnimation {
                                            duration: 150
                                        }
                                    }

                                    Text {
                                        text: modelData.connected ? "Disconnect" : "Connect"
                                        color: "black"
                                        font.bold: true
                                        font.pixelSize: 9
                                        anchors.centerIn: parent
                                    }
                                }
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    if (modelData.connected) {
                                        modelData.disconnect();
                                    } else {
                                        modelData.connect();
                                    }
                                }
                            }
                        }
                    }
                }

                // PAGE 3: AUDIO MIXER
                ColumnLayout {
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "❮ Back"
                            color: Config.accent
                            font.bold: true
                            MouseArea {
                                anchors.fill: parent
                                onClicked: ccPanel.activeTab = "main"
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "Volume Mixer"
                            color: Config.text
                            font.bold: true
                            font.pixelSize: 14
                        }
                    }

                    ListView {
                        id: mixerListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 8
                        model: Pipewire.nodes.values.filter(node => node.isStream && node.isSink && node.audio)

                        delegate: Rectangle {
                            width: ListView.view.width
                            height: 48
                            radius: 8
                            color: Qt.rgba(255, 255, 255, 0.03)
                            border.color: Qt.rgba(255, 255, 255, 0.05)
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 10

                                Text {
                                    text: {
                                        let name = (modelData.properties["application.name"] || "").toLowerCase();
                                        if (name.includes("spotify"))
                                            return "";
                                        if (name.includes("firefox") || name.includes("chrome") || name.includes("browser"))
                                            return "󰈹";
                                        if (name.includes("discord"))
                                            return "󰙯";
                                        if (name.includes("feishin"))
                                            return "󰎆";
                                        return "󰓃";
                                    }
                                    color: Config.accent
                                    font.pixelSize: 16
                                    Layout.preferredWidth: 20
                                    horizontalAlignment: Text.AlignHCenter
                                }

                                ColumnLayout {
                                    spacing: 2
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    Text {
                                        text: modelData.properties["application.name"] || modelData.properties["node.description"] || modelData.name || "App Stream"
                                        color: Config.text
                                        font.bold: true
                                        font.pixelSize: 11
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }

                                    Slider {
                                        Layout.fillWidth: true
                                        value: modelData.audio.volume
                                        onMoved: modelData.audio.volume = value
                                    }
                                }

                                Text {
                                    text: Math.round(modelData.audio.volume * 100) + "%"
                                    color: Config.subtext
                                    font.pixelSize: 9
                                    Layout.preferredWidth: 28
                                    horizontalAlignment: Text.AlignRight
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Caelestia-Style Slide-up App Launcher Panel
    Rectangle {
        id: launcherPanel
        x: borderWin.width / 2 - Config.launcherWidth / 2
        // y: borderWin.y_bottom - height
        y: borderWin.y_top
        width: Config.launcherWidth - 1
        height: Config.launcherHeight * borderWin.launcherProgress - 1

        // topLeftRadius: borderWin.rounding
        // topRightRadius: borderWin.rounding
        // bottomLeftRadius: 0
        // bottomRightRadius: 0
        topLeftRadius: 0
        topRightRadius: 0
        bottomLeftRadius: borderWin.rounding
        bottomRightRadius: borderWin.rounding

        color: Config.mantle
        // border.color: Config.glassBorder
        border.width: 0
        clip: true

        visible: borderWin.launcherProgress > 0.01
        opacity: borderWin.launcherProgress

        Rectangle {
            // anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 1
            anchors.rightMargin: 1
            height: 1
            color: Config.mantle
            z: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            ListView {
                id: launcherList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 4
                model: borderWin.filteredApps
                currentIndex: borderWin.launcherSelectedIndex
                onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)

                delegate: Rectangle {
                    width: ListView.view.width
                    height: 36
                    radius: 6
                    color: index === borderWin.launcherSelectedIndex ? Qt.rgba(Config.accent.r, Config.accent.g, Config.accent.b, 0.15) : (launcherItemMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.05) : "transparent")
                    border.color: index === borderWin.launcherSelectedIndex ? Config.accent : "transparent"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 8

                        Image {
                            source: "image://icon/" + modelData.icon
                            sourceSize.width: 24
                            sourceSize.height: 24
                            Layout.alignment: Qt.AlignVCenter
                        }
                        // Text {
                        //     text: "󰀻"
                        //     color: index === borderWin.launcherSelectedIndex ? Config.accent : Config.overlay
                        //     font.pixelSize: 14
                        // }

                        Text {
                            text: modelData.name
                            color: Config.text
                            font.pixelSize: 12
                            font.bold: index === borderWin.launcherSelectedIndex
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea {
                        id: launcherItemMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            borderWin.launcherSelectedIndex = index;
                            borderWin.launchSelected();
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Qt.rgba(255, 255, 255, 0.08)
            }

            RowLayout {
                spacing: 8
                Layout.fillWidth: true
                Layout.preferredHeight: 32

                Text {
                    text: ""
                    color: Config.subtext
                    font.pixelSize: 14
                }

                TextField {
                    id: launcherSearchInput
                    placeholderText: "Search applications..."
                    color: Config.text
                    font.pixelSize: 13
                    Layout.fillWidth: true
                    focus: borderWin.launcherProgress > 0.9

                    background: Item {}

                    onTextChanged: borderWin.filterApps(text)

                    Keys.onPressed: event => {
                        if ((event.modifiers & Qt.ControlModifier) && event.key === Qt.Key_A) {
                            launcherSearchInput.selectAll();
                            event.accepted = true;
                        }
                        if (event.key === Qt.Key_Escape) {
                            borderWin.launcherOpen = false;
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Down) {
                            borderWin.launcherSelectedIndex = Math.min(borderWin.filteredApps.length - 1, borderWin.launcherSelectedIndex + 1);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Up) {
                            borderWin.launcherSelectedIndex = Math.max(0, borderWin.launcherSelectedIndex - 1);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            borderWin.launchSelected();
                            event.accepted = true;
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        borderWin.shouldStartHyprsunset = true;
        killProc.running = true;
    }
}
