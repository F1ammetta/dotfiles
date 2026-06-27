local mainMod = "SUPER"

-- Clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("alacritty --class clipse -e clipse"))

-- Power
hl.bind(mainMod .. " + ALT + SHIFT + S", hl.dsp.exec_cmd("poweroff"))
hl.bind(mainMod .. " + ALT + SHIFT + R", hl.dsp.exec_cmd("reboot"))
hl.bind(mainMod .. " + ALT + SHIFT + CTRL + R", hl.dsp.exec_cmd("sudo grub-reboot 2 && reboot"))
hl.bind(mainMod .. " + ALT + U", hl.dsp.dpms({ action = "on" }))
hl.bind(mainMod .. " + ALT + L", hl.dsp.dpms({ action = "off" }))
hl.bind(mainMod .. " + CTRL + A", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"))

-- Mute
hl.bind("PAUSE", hl.dsp.exec_cmd("pactl set-source-mute $(pactl get-default-source) toggle"))

-- Screenshot region
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp -b 333333aa -c 72c5ff)" - | wl-copy'))

-- Terminal (kitty)
hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd(kitty))

-- Apps
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(files))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + G", hl.dsp.workspace.toggle_special("gemini"))

-- Rofi / launchers
hl.bind(mainMod .. " + SPACE", hl.dsp.global("quickshell:launcher"), { global = true })
hl.bind(mainMod .. " + U", hl.dsp.global("quickshell:visible"), { global = true })
hl.bind(mainMod .. " + BACKSPACE", hl.dsp.global("quickshell:cc"), { global = true })
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd(rofi_runner))
hl.bind("ALT + F1", hl.dsp.global("quickshell:launcher"), { global = true })
hl.bind("ALT + F2", hl.dsp.exec_cmd(rofi_runner))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(rofi_asroot))
hl.bind(mainMod .. " + M", hl.dsp.workspace.toggle_special("thunderbird"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(rofi_network))
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd(rofi_bluetooth))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(rofi_powermenu))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(rofi_screenshot))

-- Color picker
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(colorpicker))

-- Function keys
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(backlight .. " --inc"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(backlight .. " --dec"), { repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volume .. " --inc"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volume .. " --dec"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(volume .. " --toggle"), { repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(volume .. " --toggle-mic"), { repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl -p playerctld next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl -p playerctld previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl -p playerctld play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl -p playerctld pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl -p playerctld stop"), { locked = true })

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd(screenshot .. " --now"))
hl.bind("ALT + Print", hl.dsp.exec_cmd(screenshot .. " --in5"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(screenshot .. " --in10"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd(screenshot .. " --win"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(screenshot .. " --area"))

-- Hyprland window management
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + ALT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + backslash", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))

-- Move focus (vim keys)
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move window
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

-- Resize active
hl.bind(mainMod .. " + CTRL + h", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -20 0"), { repeating = true })
hl.bind(mainMod .. " + CTRL + l", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 20 0"), { repeating = true })
hl.bind(mainMod .. " + CTRL + k", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -20"), { repeating = true })
hl.bind(mainMod .. " + CTRL + j", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 20"), { repeating = true })

-- Move active (floating only)
hl.bind(mainMod .. " + ALT + h", hl.dsp.exec_cmd("hyprctl dispatch moveactive -20 0"), { repeating = true })
hl.bind(mainMod .. " + ALT + k", hl.dsp.exec_cmd("hyprctl dispatch moveactive 0 -20"), { repeating = true })
hl.bind(mainMod .. " + ALT + j", hl.dsp.exec_cmd("hyprctl dispatch moveactive 0 20"), { repeating = true })

-- Cycle windows
hl.bind("ALT + Tab", hl.dsp.exec_cmd("hyprctl dispatch cyclenext"))
hl.bind("ALT + Tab", hl.dsp.exec_cmd("hyprctl dispatch bringactivetotop"))

-- Workspace switching with hyprsplit
for w = 1, 10 do
	local i = w == 10 and 0 or w
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = w }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hs.dsp.window.move({ workspace = w }))
end

-- Workspace options
-- TODO: Fix if i ever need it
-- hl.bind(mainMod .. " + CTRL + F", hl.dsp.exec_cmd("hyprctl dispatch workspaceopt allfloat"))
-- hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("hyprctl dispatch workspaceopt allpseudo"))

-- Misc
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.pin({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(notifycmd .. "Toggled Pin"))
-- hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("hyprctl dispatch swapnext"))

-- Special workspaces
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("spotify"))
hl.bind(mainMod .. " + Y", hl.dsp.workspace.toggle_special("feishin"))
hl.bind(mainMod .. " + I", hl.dsp.workspace.toggle_special("bolsillo"))
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.window.move({ workspace = "special:bolsillo" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(discord))
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("hyprctl dispatch workspace previous"))

-- Screen recording
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/record_screen"))
hl.bind(mainMod .. " + SHIFT + ALT + G", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle_replay"))
hl.bind(mainMod .. " + ALT + G", hl.dsp.exec_cmd("~/.config/hypr/scripts/save_replay"))

-- Mouse binds
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
