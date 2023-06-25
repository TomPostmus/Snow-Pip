spin_radius = 240 // radius of spin trajectory
spin_init_dir = undefined // initial direction of throw
spin_max_turn = 180 // maximum turn direction of trajectory

// Apply force to hit pip
function impact_pip(pip) {
	// calculate impulse based on speed of snowball
	var imp_scaling = 0.03 // how much to scale impulse
	var imp_x = speed_x * imp_scaling
	var imp_y = speed_y * imp_scaling
	
	with(pip.collision)
		physics_apply_impulse(x, y, imp_x, imp_y)
}