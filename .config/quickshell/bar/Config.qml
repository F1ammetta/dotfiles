pragma Singleton
import QtQuick

QtObject {
    id: root

    // Layout and sizing config
    property int borderThickness: 2
    property int borderRounding: 10
    property int borderMargins: 10
    property int barHeight: 47
    property int barMargins: 10
    property int launcherWidth: 420
    property int launcherHeight: 320

    // System theme toggle
    property bool useSystemTheme: true

    property SystemPalette sysPalette: SystemPalette {
        colorGroup: SystemPalette.Active
    }

    // Theme Colors (Catppuccin Mocha themed by default, or following system theme)
    property color bg: useSystemTheme ? sysPalette.window : "#1e1e2e"
    property color crust: useSystemTheme ? Qt.darker(sysPalette.window, 1.2) : "#11111b"
    property color mantle: useSystemTheme ? Qt.darker(sysPalette.window, 1.1) : "#181825"
    property color text: useSystemTheme ? sysPalette.windowText : "#cdd6f4"
    property color subtext: useSystemTheme ? Qt.rgba(sysPalette.windowText.r, sysPalette.windowText.g, sysPalette.windowText.b, 0.7) : "#a6adc8"
    property color overlay: useSystemTheme ? Qt.rgba(sysPalette.windowText.r, sysPalette.windowText.g, sysPalette.windowText.b, 0.5) : "#6c7086"
    property color accent: useSystemTheme ? sysPalette.highlight : "#cba6f7"
    property color activeAccent: useSystemTheme ? sysPalette.highlight : "#b4befe"
    property color green: "#a6e3a1"
    property color red: "#f38ba8"
    property color yellow: "#f9e2af"
    property color blue: useSystemTheme ? sysPalette.highlight : "#89b4fa"
    property color glassBg: useSystemTheme ? sysPalette.window : "#11111b"
    property color glassBorder: useSystemTheme ? Qt.rgba(sysPalette.windowText.r, sysPalette.windowText.g, sysPalette.windowText.b, 0.1) : "#1affffff"

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
