// Listen for user input
if (!external_input) {
	var lateral = keyboard_check(ord("A")) - keyboard_check(ord("D"))
	var axial = keyboard_check(ord("W")) - keyboard_check(ord("S"))
	
	// Move pip
	pip.collision.phy_position_x += 
		lengthdir_x(axial, pip.rotation) +
		lengthdir_x(lateral, pip.rotation + 90)
	pip.collision.phy_position_y += 
		lengthdir_y(axial, pip.rotation) +
		lengthdir_y(lateral, pip.rotation + 90)
		
	// Mouse turning movement
	var disp_x = window_mouse_get_x() - mouse_prev_x	// x displacement of mouse
	mouse_prev_x = window_mouse_get_x()
	
	var sensitivity = 1
	pip.rotation -= disp_x * sensitivity			// update pip rotation
}