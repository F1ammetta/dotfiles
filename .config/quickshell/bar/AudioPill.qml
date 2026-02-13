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
    iconColor: Audio.muted ? "#f38ba8" : activePalette.highlight

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        // Use the helper functions from the Singleton
        onClicked: Hyprland.dispatch("exec pulsemixer --toggle-mute")

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
