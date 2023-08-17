// Surfaces
view_main_w = 640 // dimensions of viewports
view_main_h = 480
view_log_w = 240
surface_gui = noone // surface on top of main surface with GUI markers
surface_log = noone // log surface on the side of main surface

// Window size & position
window_w = view_main_w + view_log_w
window_set_size(window_w, view_main_h)
var display_w = display_get_width()
window_set_position(display_w / 2 - window_w / 2, 30)
surface_resize(application_surface, window_w, view_main_h)
window_set_caption("Server")

// Set viewport size
for (var rm = 0; room_exists(rm); rm ++) {
	room_set_viewport(rm, 0, true, 0, 0, view_main_w, view_main_h)
	room_set_viewport(rm, 1, true, view_main_w, 0, view_log_w, view_main_h)
}

room_goto_next()

// Convert position to GUI layer coordinate
function gui_x(_x) {
	return _x / room_width * view_main_w
} 

function gui_y(_y) {
	return _y / room_height * view_main_h
} 