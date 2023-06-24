// Set view at camera location
camera_set_view_pos(view_camera[0],
	x - width / 2,		// set at top left corner
	y - height / 2)
	
// Bounding at room bounds
var target_x = clamp(target.x, width / 2, room_width - width / 2)
var target_y = clamp(target.y, height / 2, room_height - height / 2)
	
// Smooth following (P-controller)
var p = 0.1
x += (target_x - x) * p
y += (target_y - y) * p