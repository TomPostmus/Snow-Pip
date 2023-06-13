// Listen for user input
if (!external_input) {
	var lateral = keyboard_check(ord("A")) - keyboard_check(ord("D"))
	var axial = keyboard_check(ord("W")) - keyboard_check(ord("S"))
	
	pip.input_lateral = lateral
	pip.input_axial = axial
	
	// Move pip
	pip.collision.phy_position_x += 
		lengthdir_x(axial, pip.rotation) +
		lengthdir_x(lateral, pip.rotation + 90)
	pip.collision.phy_position_y += 
		lengthdir_y(axial, pip.rotation) +
		lengthdir_y(lateral, pip.rotation + 90)
		
	// Mouse turning movement
	var disp_x = window_mouse_get_x() - window_get_width()/2	// x displacement of mouse
	window_mouse_set(window_get_width()/2, window_get_height()/2)
	window_set_cursor(cr_none)
	
	var sensitivity = 1
	pip.rotation -= disp_x * sensitivity			// update pip rotation
}