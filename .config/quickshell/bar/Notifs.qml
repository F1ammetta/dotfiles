import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

Item {
    id: root
    required property var modelData

    property bool closing: false
    property bool expanded: false

    Layout.preferredHeight: closing ? 0 : rect.height
    Layout.fillWidth: true
    width: 350
    implicitHeight: rect.height

    Behavior on Layout.preferredHeight {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        id: rect
        width: parent.width
        height: layout.implicitHeight + 20
        color: Config.mantle
        radius: 12
        border.color: Config.accent
        border.width: 1
        clip: true

        x: root.closing ? parent.width : (entranceHelper.active ? 0 : parent.width)
        opacity: root.closing ? 0 : (entranceHelper.active ? 1 : 0)
        scale: root.closing ? 0.8 : (entranceHelper.active ? 1 : 0.8)

        Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

        QtObject {
            id: entranceHelper
            property bool active: false
        }

        Component.onCompleted: {
            entranceHelper.active = true;
        }

        ColumnLayout {
            id: layout
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 10
            spacing: 8

            // Header Row: Icon, Summary, Chevron
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                // Image/Icon
                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: Qt.rgba(255, 255, 255, 0.05)
                    clip: true
                    Layout.alignment: Qt.AlignVCenter

                    Image {
                        anchors.fill: parent
                        source: (root.modelData && root.modelData.image) ? root.modelData.image : ""
                        visible: source != ""
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                    }

                    Text {
                        text: "🔔"
                        anchors.centerIn: parent
                        visible: !parent.children[0].visible
                        font.pixelSize: 14
                    }
                }

                // Summary / Title
                ColumnLayout {
                    spacing: 1
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        text: root.modelData ? root.modelData.summary : "Notification"
                        color: "white"
                        font.bold: true
                        font.pixelSize: 12
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: root.modelData ? root.modelData.appName : ""
                        color: Config.subtext
                        font.pixelSize: 9
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                // Expand/Collapse Chevron Button
                Text {
                    text: root.expanded ? "" : ""
                    color: Config.accent
                    font.pixelSize: 14
                    font.bold: true
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Layout.alignment: Qt.AlignVCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.expanded = !root.expanded
                    }
                }
            }

            // Body Text Row
            Text {
                text: root.modelData ? root.modelData.body : ""
                color: "#bac2de"
                font.pixelSize: 11
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                Layout.fillWidth: true
                maximumLineCount: root.expanded ? 100 : 2
                elide: root.expanded ? Text.ElideNone : Text.ElideRight
            }

            // Action Buttons Row (visible only when expanded)
            RowLayout {
                Layout.fillWidth: true
                visible: root.expanded && root.modelData && root.modelData.actions && root.modelData.actions.length > 0
                spacing: 8

                Repeater {
                    model: (root.modelData && root.modelData.actions) ? root.modelData.actions : null
                    delegate: Rectangle {
                        implicitWidth: actionLabel.implicitWidth + 20
                        height: 24
                        radius: 12
                        color: actionMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.05)
                        border.color: actionMouseArea.containsMouse ? Config.accent : Qt.rgba(255, 255, 255, 0.08)
                        border.width: 1

                        Text {
                            id: actionLabel
                            text: modelData.text
                            color: "white"
                            font.pixelSize: 9
                            font.bold: true
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            id: actionMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                modelData.invoke();
                                dismissWithAnim();
                            }
                        }
                    }
                }
            }
        }

        // Click to trigger default action
        MouseArea {
            anchors.fill: parent
            z: -1 // Behind text/buttons so they can be clicked
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: mouse => {
                if (mouse.button === Qt.RightButton) {
                    dismissWithAnim();
                } else if (mouse.button === Qt.LeftButton) {
                    if (root.modelData && root.modelData.defaultAction) {
                        root.modelData.defaultAction.invoke();
                        dismissWithAnim();
                    }
                }
            }
        }
    }

    Connections {
        target: root.modelData
        ignoreUnknownSignals: true
        function onClosed() {
            if (!root.closing)
                dismissWithAnim();
        }
    }

    function dismissWithAnim() {
        if (root.closing)
            return;
        root.closing = true;
        destroyTimer.start();
    }

    Timer {
        id: destroyTimer
        interval: 350
        onTriggered: {
            if (root.modelData && typeof root.modelData.dismiss === "function") {
                root.modelData.dismiss();
            }
            root.destroy();
        }
    }

    Timer {
        interval: 6000 // auto dismiss after 6s
        running: !root.closing && !expanded
        onTriggered: dismissWithAnim()
    }
}
