// AudioPill.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell

StatPill {
    id: audioPill

    // Bind directly to the Singleton properties
    icon: {
        if (Audio.muted)
            return "";
        let vol = Audio.volume * 100;
        if (vol <= 0)
            return "";
        if (vol < 50)
            return "";
        return "";
    }

    label: Audio.muted ? "Mute" : Math.round(Audio.volume * 100) + "%"
    iconColor: Audio.muted ? Config.red : Config.accent

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                Audio.toggleMute();
            } else if (mouse.button === Qt.RightButton) {
                root.ccOpen = !root.ccOpen;
            }
        }

        onWheel: wheel => {
            let step = 0.05;
            if (wheel.angleDelta.y > 0) {
                Audio.setVolume(Audio.volume + step);
            } else {
                Audio.setVolume(Audio.volume - step);
            }
        }
    }
}

