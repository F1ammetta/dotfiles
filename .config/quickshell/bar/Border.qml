import QtQuick
import Quickshell

Item {
    id: root

    anchors.fill: parent

    Rectangle {
        // This is what will be visible as the border
        anchors.fill: parent
        color: activePalette.dark // Using the palette from the original shell.qml

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
            invert: true
        }
    }

    // The item that defines the shape of the hole
    Item {
        id: mask
        anchors.fill: parent
        layer.enabled: true
        visible: false // The mask itself is not rendered

        Rectangle {
            id: maskRect
            anchors.fill: parent
            // The margins create the border thickness
            anchors.margins: Config.borderThickness
            // Use the configured corner rounding
            radius: Config.borderRounding
        }
    }

    // We need this to get the activePalette color
    SystemPalette {
        id: activePalette
        colorGroup: SystemPalette.Active
    }
}