import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property alias icon: iconText.text
    property alias label: labelText.text
    property color iconColor: Config.accent

    // FIX 1: Use implicitWidth instead of width.
    // This tells the RowLayout how much space we actually need.
    implicitWidth: layout.implicitWidth + 24

    // FIX 2: Set Layout.fillHeight to true instead of using anchors.
    // This centers the pill vertically within the bar automatically.
    Layout.fillHeight: true
    Layout.topMargin: 2
    Layout.bottomMargin: 2

    radius: 8
    color: Qt.rgba(1, 1, 1, 0.08)

    RowLayout {
        id: layout
        // Center the content inside the pill
        anchors.centerIn: parent
        spacing: 8

        Text {
            id: iconText
            color: root.iconColor
            font.pixelSize: 14
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: labelText
            color: "white"
            font.pixelSize: 13
            font.bold: true
            verticalAlignment: Text.AlignVCenter
        }
    }
}
