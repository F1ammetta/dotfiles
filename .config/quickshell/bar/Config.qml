pragma Singleton
import QtQuick

QtObject {
    property var notifs: QtObject {
        property var sizes: QtObject {
            property int width: 350
            property int image: 64
            property int badge: 24
        }
        property bool openExpanded: false
        property real clearThreshold: 0.5
        property int expandThreshold: 10
        property bool actionOnClick: true
        property int defaultExpireTimeout: 5000
        property bool expire: true
    }
    property var utilities: QtObject {
        property var toasts: QtObject {
            property bool dndChanged: true
        }
    }
}