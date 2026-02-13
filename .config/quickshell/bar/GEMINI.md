# Project Overview

This project is a collection of QML widgets designed to create a status bar for the Quickshell desktop environment. The bar displays system information, media controls, and workspace indicators.

**Technologies:**
*   **QML:** The user interface is built entirely with QML, the declarative UI language of the Qt framework.
*   **Quickshell:** The components are designed to integrate with the Quickshell environment, utilizing its services for system interaction (e.g., Pipewire for audio, Hyprland for window management).

**Architecture:**
*   **`shell.qml`:** The main entry point that creates the bar window.
*   **`Bar.qml`:** The central component that arranges the different widgets.
*   **Widgets:** The bar is composed of several modular widgets:
    *   `Spotify.qml`: Controls for Spotify.
    *   `AudioPill.qml`: Displays volume level.
    *   `StatPill.qml`: A generic component for displaying statistics.
    *   `VolumeOSD.qml`: An on-screen display for volume.
*   **Services:**
    *   `Audio.qml`: A singleton that manages audio state via Pipewire.

# Key Files

*   **`shell.qml`**: The main QML file that defines the bar window and its properties. It contains the `Bar.qml` component.
*   **`Bar.qml`**: Defines the layout of the bar, including the system tray, Spotify widget, CPU and clock pills, and workspace indicators.
*   **`Spotify.qml`**: A widget that displays the currently playing song on Spotify and provides controls for play/pause, next, and previous. It uses an external script (`/home/fiammetta/.config/hypr/waybar/spotify`) to fetch the information.
*   **`StatPill.qml`**: A reusable component for displaying a piece of information with an icon and a label.
*   **`AudioPill.qml`**: A specific implementation of `StatPill` for displaying the current audio volume and mute status.
*   **`Audio.qml`**: A singleton QML object for interacting with Pipewire to get and set audio volume and mute status.
*   **`VolumeOSD.qml`**: An on-screen display that appears when the volume is changed.

# Building and Running

This project is not a standalone application but a component for Quickshell. To use it, you need to have Quickshell installed and configured to load the `shell.qml` file.

**TODO:** Add specific instructions on how to configure Quickshell to use this bar.

# Development Conventions

*   **QML:** The project uses QML for UI and logic.
*   **Singleton:** The `Audio.qml` file is a singleton, providing a global point of access to audio state.
*   **External Scripts:** The `Spotify.qml` widget relies on an external shell script for its data.
*   **Styling:** The UI is styled using properties and simple rectangles, with colors from the system palette.
