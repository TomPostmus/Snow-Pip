if (local) {

}

// Listen for user input
if (instance_exists(player.pip)) {
	var pip = player.pip
	
	// Move input
	var lateral = keyboard_check(ord("A")) - keyboard_check(ord("D"))
	var forward = keyboard_check(ord("W"))
	var backward = keyboard_check(ord("S"))
	
	pip.input_axial = forward - backward
	pip.input_lateral = lateral
	
	// Move pip
	var disp_axial = !(forward && backward) * (forward * 1.7 - backward * 1.2) // displacement
	var disp_lateral = lateral * 0.8
	pip.collision.phy_position_x += 
		lengthdir_x(disp_axial, pip.rotation) +
		lengthdir_x(disp_lateral, pip.rotation + 90)
	pip.collision.phy_position_y += 
		lengthdir_y(disp_axial, pip.rotation) +
		lengthdir_y(disp_lateral, pip.rotation + 90)
		
	// Mouse turning movement
	var disp_x = window_mouse_get_x() - window_get_width()/2	// x displacement of mouse
	window_mouse_set(window_get_width()/2, window_get_height()/2)
	window_set_cursor(cr_none)
	
	var sensitivity = 0.8
	var max_disp_rotation = 20					// maximum rotation displacement each time step
	var disp_rotation = clamp(-disp_x * sensitivity,
		-max_disp_rotation, max_disp_rotation)
		
	pip.rotation += disp_rotation				// update pip rotation
	
	// Snowball input
	pip.input_mb_left = mouse_check_button(mb_left)
	pip.input_mb_left_press = mouse_check_button_pressed(mb_left)
	pip.input_mb_left_release = mouse_check_button_released(mb_left)	
	
	pip.input_mb_right = mouse_check_button(mb_right)
	pip.input_mb_right_press = mouse_check_button_pressed(mb_right)
	pip.input_mb_right_release = mouse_check_button_released(mb_right)	
}