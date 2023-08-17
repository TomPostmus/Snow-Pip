// Default target
if (target_select == -1) {
	var _player = instance_find(obj_player_local, 0)			// find first local player
	if (instance_exists(_player.pip))
		target = _player.pip.collision							// set target
} else {
	var _player = instance_find(obj_player, target_select)		// find player with id selector
	if (instance_exists(_player.pip))
		target = _player.pip.collision							// set target
}

// Selector
if (keyboard_check_pressed(vk_pageup))
	target_select = (target_select + 1)
		mod instance_number(obj_player)							// increase selector and do modulo
if (keyboard_check_pressed(vk_pagedown))
	target_select =
		(target_select - 1 + instance_number(obj_player))
		mod instance_number(obj_player)							// decrease selector and do modulo


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