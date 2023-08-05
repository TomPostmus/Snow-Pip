// Find target
target = instance_find(obj_pip_collision, 0)

// Set view at camera location
camera_set_view_pos(view_camera[0],
	x - width / 2,		// set at top left corner
	y - height / 2)
	
// Set target location (away from room bounds)
var target_x, target_y
if (instance_exists(target)) {
	target_x = clamp(target.x, width / 2, room_width - width / 2)
	target_y = clamp(target.y, height / 2, room_height - height / 2)
} else {
	target_x = width / 2 // default position
	target_y = height / 2
}
	
// Smooth following (P-controller)
var p = 0.1
x += (target_x - x) * p
y += (target_y - y) * p