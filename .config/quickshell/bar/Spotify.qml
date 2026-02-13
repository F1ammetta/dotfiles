import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Rectangle {
    id: spotifyWidget

    property string currentText: ""
    property string status: "offline"

    height: 30
    width: spotifyLayout.implicitWidth + 24
    // Use implicitWidth for content, but set a floor so it doesn't shrink too small
    implicitWidth: Math.max(spotifyLayout.implicitWidth + 24, 120)
    Layout.fillHeight: true
    Layout.margins: 4
    radius: 10

    // Use the theme highlight color when playing, otherwise background
    color: status === "playing" ? activePalette.highlight : "#1e1e2e"
    clip: true

    // Process to run the script
    Process {
        id: spotifyProc
        command: ["/bin/bash", "/home/fiammetta/.config/hypr/waybar/spotify"]

        stdout: StdioCollector {
            onStreamFinished: {
                let output = this.text.split('\n');
                if (output.length >= 3) {
                    spotifyWidget.currentText = output[0].trim();
                    spotifyWidget.status = output[2].trim().toLowerCase();
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (spotifyProc.running)
                spotifyProc.running = false;
            spotifyProc.running = true;
        }
    }

    RowLayout {
        id: spotifyLayout
        anchors.centerIn: parent

        Text {
            text: spotifyWidget.currentText
            // prevent text from being empty to maintain height/width stability
            visible: text !== ""
            elide: Text.ElideRight
            Layout.maximumWidth: 200 // Prevent the song title from taking over the whole bar
            color: spotifyWidget.status === "playing" ? "#11111b" : activePalette.text
            font.pixelSize: 12
            font.bold: true
        }
    }

    // Fix for Mouse Interactions
    MouseArea {
        anchors.fill: parent
        z: 10 // Ensure it's on top of the layout to catch clicks
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                Hyprland.dispatch("exec playerctl play-pause");
            } else if (mouse.button === Qt.MiddleButton) {
                Hyprland.dispatch("exec playerctl previous");
            } else if (mouse.button === Qt.RightButton) {
                Hyprland.dispatch("exec playerctl next");
            }
        }

        onWheel: wheel => {
            // angleDelta.y is positive for scroll up, negative for scroll down
            if (wheel.angleDelta.y > 0) {
                Hyprland.dispatch("exec playerctl position 5+");
            } else {
                Hyprland.dispatch("exec playerctl position 5-");
            }
        }
    }
}
