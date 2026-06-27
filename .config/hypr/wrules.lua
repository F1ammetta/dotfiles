hl.window_rule({
	name = "endfield-render",
	match = { title = "Endfield" },
	render_unfocused = true,
})

hl.window_rule({
	name = "clipse-float",
	match = { class = "clipse" },
	float = true,
})

hl.window_rule({
	name = "clipse-center",
	match = { class = "clipse" },
	center = true,
})

hl.window_rule({
	name = "qimgv-float",
	match = { class = "qimgv" },
	float = true,
})

hl.window_rule({
	name = "qimgv-center",
	match = { class = "qimgv" },
	center = true,
})

hl.window_rule({
	name = "qt5ct-float",
	match = { class = "qt5ct" },
	float = true,
})

hl.window_rule({
	name = "thunderbird-special",
	match = { class = "org.mozilla.Thunderbird" },
	workspace = "special:thunderbird silent",
})

hl.window_rule({
	name = "spotify-special",
	match = { class = "Spotify" },
	workspace = "special:spotify silent",
})

hl.window_rule({
	name = "rename-float",
	match = { title = "Rename.*" },
	float = true,
})

hl.window_rule({
	name = "rename-center",
	match = { title = "Rename.*" },
	center = true,
})

hl.window_rule({
	name = "rename-size",
	match = { title = "Rename.*" },
	size = "422 122",
})

hl.window_rule({
	name = "sleepy-launcher-float",
	match = { class = "moe.launcher.sleepy-launcher" },
	float = true,
})

hl.window_rule({
	name = "sleepy-launcher-center",
	match = { class = "moe.launcher.sleepy-launcher" },
	center = true,
})

hl.window_rule({
	name = "sleepy-launcher-size",
	match = { class = "moe.launcher.sleepy-launcher" },
	size = "922 622",
})

hl.window_rule({
	name = "xdg-desktop-portal-float",
	match = { class = "xdg-desktop-portal-gtk" },
	float = true,
})

hl.window_rule({
	name = "pavucontrol-float",
	match = { class = "org.pulseaudio.pavucontrol" },
	float = true,
})

hl.window_rule({
	name = "pavucontrol-center",
	match = { class = "org.pulseaudio.pavucontrol" },
	center = true,
})

hl.window_rule({
	name = "pavucontrol-size",
	match = { class = "org.pulseaudio.pavucontrol" },
	size = "822 622",
})

hl.window_rule({
	name = "qt5ct-center",
	match = { class = "qt5ct" },
	center = true,
})

hl.window_rule({
	name = "qt5ct-size",
	match = { class = "qt5ct" },
	size = "822 622",
})

hl.window_rule({
	name = "qt6ct-float",
	match = { class = "qt6ct" },
	float = true,
})

hl.window_rule({
	name = "file-float",
	match = { class = "file-.*" },
	float = true,
})

hl.window_rule({
	name = "qt6ct-center",
	match = { class = "qt6ct" },
	center = true,
})

hl.window_rule({
	name = "qt6ct-size",
	match = { class = "qt6ct" },
	size = "822 622",
})

hl.window_rule({
	name = "fcitx5-config-float",
	match = { class = "org.fcitx.fcitx5-config-qt" },
	float = true,
})

hl.window_rule({
	name = "fcitx5-config-center",
	match = { class = "org.fcitx.fcitx5-config-qt" },
	center = true,
})

hl.window_rule({
	name = "kdeconnect-float",
	match = { class = "org.kde.kdeconnect.app" },
	float = true,
})

hl.window_rule({
	name = "kdeconnect-center",
	match = { class = "org.kde.kdeconnect.app" },
	center = true,
})

hl.window_rule({
	name = "kdeconnect-size",
	match = { class = "org.kde.kdeconnect.app" },
	size = "822 622",
})

hl.window_rule({
	name = "clipse-size",
	match = { class = "clipse" },
	size = "622 652",
})

hl.window_rule({
	name = "libnode-float",
	match = { title = "libnode" },
	float = true,
})

hl.window_rule({
	name = "pip-float",
	match = { title = "Picture-in-Picture" },
	float = true,
})

hl.window_rule({
	name = "pip-size",
	match = { title = "Picture-in-Picture" },
	size = "567 326",
})

hl.window_rule({
	name = "pip-move",
	match = { title = "Picture-in-Picture" },
	move = "1311 71",
})

hl.window_rule({
	name = "chromium-tile",
	match = { class = "Chromium" },
	tile = true,
})

hl.window_rule({
	name = "main-float",
	match = { class = "main" },
	float = true,
})

hl.window_rule({
	name = "file-op-progress-float",
	match = { title = "File Operation Progress" },
	float = true,
})

hl.window_rule({
	name = "confirm-replace-float",
	match = { title = "Confirm to replace files" },
	float = true,
})

hl.window_rule({
	name = "simple-glium-float",
	match = { title = "Simple Glium Window" },
	float = true,
})

hl.window_rule({
	name = "simple-glium-monitor",
	match = { title = "Simple Glium Window" },
	monitor = "HDMI-A-1",
})

hl.window_rule({
	name = "blueman-float",
	match = { class = "blueman-manager" },
	float = true,
})

hl.window_rule({
	name = "blueman-size",
	match = { class = "blueman-manager" },
	size = "622 522",
})

hl.window_rule({
	name = "blueman-center",
	match = { class = "blueman-manager" },
	center = true,
})

hl.window_rule({
	name = "gemini-special",
	match = { class = "chrome-gemini.google.com__-Default" },
	workspace = "special:gemini silent",
})

hl.window_rule({
	name = "feishin-special",
	match = { class = "feishin" },
	workspace = "special:feishin silent",
})

hl.window_rule({
	name = "discord-workspace",
	match = { class = "discord" },
	workspace = "2",
})

hl.window_rule({
	name = "fcitx-config-gtk3-float",
	match = { class = "fcitx-config-gtk3" },
	float = true,
})
