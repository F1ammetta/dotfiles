pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSource, Pipewire.defaultAudioSink, Pipewire.nodes, Pipewire.links]
    }

    property var sinks: Pipewire.nodes.values.filter(node => node.isSink && !node.isStream && node.audio)
    property PwNode defaultSink: Pipewire.defaultAudioSink

    property var sources: Pipewire.nodes.values.filter(node => !node.isSink && !node.isStream && node.audio)
    property PwNode defaultSource: Pipewire.defaultAudioSource

    property real volume: (defaultSink && defaultSink.audio) ? defaultSink.audio.volume : 0
    property bool muted: (defaultSink && defaultSink.audio) ? defaultSink.audio.muted : false

    property real sourceVolume: (defaultSource && defaultSource.audio) ? defaultSource.audio.volume : 0
    property bool sourceMuted: (defaultSource && defaultSource.audio) ? defaultSource.audio.muted : false

    function setVolume(to) {
        if (defaultSink && defaultSink.ready && defaultSink.audio) {
            defaultSink.audio.muted = false;
            defaultSink.audio.volume = Math.max(0, Math.min(1, to));
        }
    }

    function toggleMute() {
        if (defaultSink && defaultSink.ready && defaultSink.audio) {
            defaultSink.audio.muted = !defaultSink.audio.muted;
        }
    }

    function setSourceVolume(to) {
        if (defaultSource && defaultSource.ready && defaultSource.audio) {
            defaultSource.audio.muted = false;
            defaultSource.audio.volume = Math.max(0, Math.min(1, to));
        }
    }

    function toggleSourceMute() {
        if (defaultSource && defaultSource.ready && defaultSource.audio) {
            defaultSource.audio.muted = !defaultSource.audio.muted;
        }
    }

    function setDefaultSink(sink) {
        Pipewire.preferredDefaultAudioSink = sink;
    }

    function setDefaultSource(source) {
        Pipewire.preferredDefaultAudioSource = source;
    }

    function init() {
    }
}

