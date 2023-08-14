// Get local input
if (player.local) {
	// Find relative player id
	var _relative_playid = 0 // indicates relative player id of this input
	with (obj_player_local) {
		if (self == other.player) break
		_relative_playid ++
	}
	
	// Get input
	if (_relative_playid == 0) {
		left = keyboard_check(ord("A"))
		right = keyboard_check(ord("D"))
		forward = keyboard_check(ord("W"))
		backward = keyboard_check(ord("S"))
		
		// Snowball input
		mouse_left = mouse_check_button(mb_left)
		mouse_left_press = mouse_check_button_pressed(mb_left)
		mouse_left_release = mouse_check_button_released(mb_left)	
	
		mouse_right = mouse_check_button(mb_right)
		mouse_right_press = mouse_check_button_pressed(mb_right)
		mouse_right_release = mouse_check_button_released(mb_right)	
	} else if (_relative_playid == 1) {
		left = keyboard_check(vk_left)
		right = keyboard_check(vk_right)
		forward = keyboard_check(vk_up)
		backward = keyboard_check(vk_down)
	}	
}

// Get input from server
if (!player.local) {
	left = player.received_in_left
	right = player.received_in_right
	forward = player.received_in_forward
	backward = player.received_in_backward
}