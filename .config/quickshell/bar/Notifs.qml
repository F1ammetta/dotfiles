import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

Rectangle {
    id: root
    required property var modelData

    // Safeguard flag to prevent double-execution
    property bool closing: false
    Layout.preferredHeight: implicitHeight
    Layout.fillWidth: true
    width: 350
    implicitHeight: layout.implicitHeight + 24
    color: activePalette.dark
    radius: 12
    border.color: activePalette.highlight
    border.width: 1

    // Entrance logic
    x: width
    Component.onCompleted: x = 0

    Behavior on Layout.preferredHeight {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    Behavior on x {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    // Monitor for system-side closure
    Connections {
        target: root.modelData
        // ignoreUnknownSignals prevents errors if the object is partially destroyed
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

        root.x = root.width;
        // 3. Shrink the height to 0 to slide the list up smoothly
        root.Layout.preferredHeight = 0;

        destroyTimer.start();
    }

    clip: true

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

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Image {
            source: (root.modelData && root.modelData.image) ? root.modelData.image : ""
            visible: source != ""
            Layout.preferredWidth: 60
            Layout.preferredHeight: 60
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
        }

        ColumnLayout {
            Layout.fillWidth: true

            Text {
                text: root.modelData ? root.modelData.summary : ""
                color: "white"
                font.bold: true
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                text: root.modelData ? root.modelData.body : ""
                color: "#bac2de"
                font.pixelSize: 11
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                maximumLineCount: 3
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                dismissWithAnim();
            } else if (mouse.button === Qt.LeftButton) {
                // Safely invoke actions
                if (root.modelData && root.modelData.defaultAction) {
                    root.modelData.defaultAction.invoke();
                } else
                // 2. Fallback: Search the actions list for the "default" ID
                if (root.modelData && root.modelData.actions) {
                    const defaultAct = root.modelData.actions.find(a => a.id === "default");
                    if (defaultAct)
                        defaultAct.invoke();
                }
                // dismissWithAnim();
            }
        }
    }

    Timer {
        interval: 5000
        running: !root.closing
        onTriggered: dismissWithAnim()
    }
}
