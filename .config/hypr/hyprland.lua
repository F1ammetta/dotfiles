require("vars")
hs = require("hyprsplit")
require("keybinds")
require("monitors")
require("animations")
require("wrules")
require("startup")

hs.config({ num_workspaces = 10 })

hl.env("VISUAL", "nvim")
hl.env("EDITOR", "nvim")
hl.env("XDG_MENU_PREFIX", "arch-")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("NR_FORCE_DARK_MODE", "1")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QUICK_CONTROLS_STYLE", "org.kde.desktop")

hl.config({
	general = {
		gaps_in = hypr_gaps_in,
		gaps_out = hypr_gaps_out,

		border_size = hypr_border_size,

		col = {
			active_border = { colors = { active_border_col_1, active_border_col_2 }, angle = gradient_angle },
			inactive_border = { colors = { inactive_border_col_1, inactive_border_col_2 }, angle = gradient_angle },
			nogroup_border_active = group_border_active_col,
		},

		layout = "dwindle",
		no_focus_fallback = false,
		resize_on_border = false,
		extend_border_grab_area = 15,
		hover_icon_on_border = true,
		allow_tearing = true,
		resize_corner = 0,

		snap = {
			enabled = false,
			window_gap = 10,
			monitor_gap = 10,
			border_overlap = false,
		},
	},

	decoration = {
		rounding = hypr_rounding,

		active_opacity = 1.0,
		inactive_opacity = 1.0,
		fullscreen_opacity = 1.0,

		dim_inactive = false,
		dim_strength = 0.5,
		dim_special = 0.2,
		dim_around = 0.4,

		blur = {
			enabled = false,
			size = 8,
			passes = 1,
			ignore_opacity = false,
			new_optimizations = true,
			xray = false,
			noise = 0.0117,
			contrast = 0.8916,
			brightness = 0.8172,
			vibrancy = 0.1696,
			vibrancy_darkness = 0.0,
		},

		shadow = {
			enabled = true,
			range = 25,
			render_power = 3,
			color = active_shadow_col,
			color_inactive = inactive_shadow_col,
		},
	},

	input = {
		kb_layout = "us,latam",
		kb_variant = "",
		kb_model = "",
		kb_rules = "",

		numlock_by_default = true,
		resolve_binds_by_sym = false,
		repeat_rate = 25,
		repeat_delay = 600,
		sensitivity = 1.0,
		accel_profile = "adaptive",
		natural_scroll = false,
		follow_mouse = 1,
		focus_on_close = 0,
		mouse_refocus = true,
		float_switch_override_focus = 1,
		special_fallthrough = false,
		off_window_axis_events = 1,

		touchpad = {
			disable_while_typing = true,
			natural_scroll = false,
			tap_to_click = true,
			drag_lock = false,
			tap_and_drag = true,
		},

		touchdevice = {
			enabled = true,
		},

		tablet = {
			relative_input = false,
		},
	},

	gestures = {
		workspace_swipe_distance = 300,
		workspace_swipe_touch = false,
		workspace_swipe_invert = true,
		workspace_swipe_touch_invert = false,
		workspace_swipe_min_speed_to_force = 30,
		workspace_swipe_cancel_ratio = 0.5,
		workspace_swipe_create_new = true,
		workspace_swipe_direction_lock = true,
		workspace_swipe_direction_lock_threshold = 10,
		workspace_swipe_forever = false,
		workspace_swipe_use_r = false,
	},

	group = {
		auto_group = true,
		insert_after_current = true,
		focus_removed_window = true,
		drag_into_group = 1,
		merge_groups_on_drag = true,
		merge_groups_on_groupbar = true,
		merge_floated_into_tiled_on_groupbar = false,
		group_on_movetoworkspace = false,

		col = {
			border_active = group_border_active_col,
			border_inactive = group_border_inactive_col,
			border_locked_active = group_border_locked_active_col,
			border_locked_inactive = group_border_locked_inactive_col,
		},

		groupbar = {
			enabled = true,
			font_family = groupbar_font_family,
			font_size = groupbar_font_size,
			gradients = true,
			height = 14,
			stacked = false,
			priority = 3,
			render_titles = true,
			scrolling = true,
			text_color = groupbar_text_color,

			col = {
				active = group_border_active_col,
				inactive = group_border_inactive_col,
				locked_active = group_border_locked_active_col,
				locked_inactive = group_border_locked_inactive_col,
			},
		},
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = false,
		font_family = groupbar_font_family,
		splash_font_family = groupbar_font_family,
		force_default_wallpaper = 0,
		vrr = false,
		mouse_move_enables_dpms = false,
		key_press_enables_dpms = false,
		always_follow_on_dnd = true,
		layers_hog_keyboard_focus = true,
		animate_manual_resizes = false,
		animate_mouse_windowdragging = false,
		disable_autoreload = false,
		enable_swallow = false,
		focus_on_activate = true,
		mouse_move_focuses_monitor = true,
		allow_session_lock_restore = false,
		background_color = "rgba(000000ff)",
		close_special_on_empty = true,
		exit_window_retains_fullscreen = false,
		initial_workspace_tracking = 1,
		middle_click_paste = true,
		render_unfocused_fps = 15,
		disable_xdg_env_checks = false,

		col = {
			splash = groupbar_text_color,
		},
	},

	binds = {
		pass_mouse_when_bound = false,
		scroll_event_delay = 300,
		workspace_back_and_forth = false,
		allow_workspace_cycles = false,
		workspace_center_on = 0,
		focus_preferred_method = 0,
		ignore_group_lock = false,
		movefocus_cycles_fullscreen = true,
		disable_keybind_grabbing = false,
		window_direction_monitor_fallback = true,
	},

	xwayland = {
		enabled = true,
		use_nearest_neighbor = true,
		force_zero_scaling = false,
	},

	opengl = {
		nvidia_anti_flicker = true,
	},

	cursor = {
		sync_gsettings_theme = true,
		no_hardware_cursors = true,
		no_break_fs_vrr = false,
		min_refresh_rate = 24,
		hotspot_padding = 1,
		inactive_timeout = 0,
		enable_hyprcursor = true,
		hide_on_key_press = false,
		hide_on_touch = false,
		zoom_factor = 1.0,
		zoom_rigid = false,
	},

	ecosystem = {
		no_update_news = true,
	},

	debug = {
		overlay = false,
		damage_blink = false,
		disable_logs = false,
		disable_time = true,
		damage_tracking = 2,
		enable_stdout_logs = false,
		suppress_errors = false,
		disable_scale_checks = false,
		error_limit = 5,
		error_position = 0,
		colored_stdout_logs = true,
	},

	render = {
		cm_auto_hdr = 0,
	},

	dwindle = {
		force_split = 0,
		preserve_split = false,
		smart_split = false,
		smart_resizing = true,
		permanent_direction_override = false,
		special_scale_factor = 0.8,
		split_width_multiplier = 1.0,
		use_active_for_splits = true,
		default_split_ratio = 1.0,
		split_bias = 0,
	},

	master = {
		allow_small_split = false,
		special_scale_factor = 0.8,
		mfact = 0.55,
		new_status = "slave",
		new_on_top = false,
		new_on_active = "none",
		orientation = "left",
		smart_resizing = true,
		drop_at_cursor = true,
	},
})
