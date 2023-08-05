// Surfaces
surface_main_w = 640 // dimensions of surfaces (surfaces are created in pre-draw)
surface_main_h = 480
surface_log_w = 240
surface_main = noone // surface on which room is drawn
surface_gui = noone // surface on top of main surface with GUI markers
surface_log = noone // log surface on the side of main surface

// Window size & position
window_w = surface_main_w + surface_log_w
window_set_size(window_w, surface_main_h)
var display_w = display_get_width()
window_set_position(display_w / 2 - window_w / 2, 30)
surface_resize(application_surface, window_w, surface_main_h)

// Set viewport size
for (var rm = 0; room_exists(rm); rm ++) {
	room_set_viewport(rm, 0, true, 0, 0, surface_main_w, surface_main_h)
	room_set_viewport(rm, 1, true, surface_main_w, 0, surface_log_w, surface_main_h)
}

room_goto_next()