target = noone
target_select = -1		// select target player with page up page down keys (-1 means pick default target)

width = 640
height = 640 / obj_init_graphics.screen_aspect
camera_set_view_size(view_camera[0], width, height)

// Function that checks whether a given point is in sight of camera
function point_in_sight(_x, _y) {
	return point_in_rectangle(
		_x, _y,
		x - width / 2, y - height / 2,
		x + width / 2, y + height / 2
	)
}

// Convert position to GUI layer coordinate
function gui_x(_x) {
	return (_x - x + width / 2) / width * display_get_gui_width()
} 

function gui_y(_y) {
	return (_y - y + height / 2) / height * display_get_gui_height()
} 