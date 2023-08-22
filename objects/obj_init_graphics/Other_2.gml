// Set full screen
full_screen = false
window_set_fullscreen(full_screen)
window_set_caption("Client " + string(MultiClientGetID()))

// Window position
if (!full_screen) {
	var window_w = window_get_width()
	var display_w = display_get_width()
	if (MultiClientGetID() == 0) {
		window_set_position(0, 500)
	} else if (MultiClientGetID() == 1) {
		window_set_position(display_w / 2, 500)
	}
}

// Resize application surface to screen/window dimensions
if (full_screen) {
	screen_aspect = display_get_width() / display_get_height()
	surface_resize(application_surface, display_get_width(), display_get_height())
} else {
	screen_aspect = window_get_width() / window_get_height()
	surface_resize(application_surface, window_get_width(), window_get_height())
}

// Resize viewport 0 of every room
for (var i = 0; room_exists(i); i ++) {
	room_set_view_enabled(i, true)
	room_set_viewport(i, 0, true, 0, 0,
		960,
		960 / screen_aspect)
}

// Go to next room (since we start in init room)
alarm[0] = MultiClientGetID() * 0 + 1