// Listen for user input
if (!external_input) {
	// Move input
	var lateral = keyboard_check(ord("A")) - keyboard_check(ord("D"))
	var axial = keyboard_check(ord("W")) - keyboard_check(ord("S"))
	
	pip.input_lateral = lateral
	pip.input_axial = axial
	
	// Move pip
	var disp_axial = axial * 1.7		// displacement
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
	var attack_left = mouse_check_button_pressed(mb_left)
	
	// Throw snowball
	if (attack_left) {
		var snowball = instance_create_layer(
			pip.collision.x + lengthdir_x(20, pip.rotation),
			pip.collision.y + lengthdir_y(20, pip.rotation),
			"Instances", obj_snowball)
		
		var throw_speed = 10
		snowball.speed_x = lengthdir_x(throw_speed, pip.rotation)
		snowball.speed_y = lengthdir_y(throw_speed, pip.rotation)
		snowball.own_pip = pip
	}
}