// Projectile vars
speed_x = 0						// fly speed
speed_y = 0
spin = false					// whether to fly with spin trajetory
type = ITEM.SNOWBALL			// what type of projectile
projectile_id = -1				// projectile id given by server (used for communication of destroy)

// Spin trajectory
spin_radius = 240				// radius of spin trajectory
spin_init_dir = undefined		// initial direction of throw
spin_max_turn = 180				// maximum turn direction of trajectory


// Apply force to hit pip
function impact_pip(pip) {
	// calculate impulse based on speed of snowball
	var imp_scaling = 0.03				// how much to scale impulse
	var imp_x = speed_x * imp_scaling
	var imp_y = speed_y * imp_scaling
	
	with(pip.collision)
		physics_apply_impulse(x, y, imp_x, imp_y)
	
	// set movement sync disable timer (to avoid stuttery impact effect for remote players)
	pip.movement_sync_disable_timer =		
		pip.movement_sync_disable_time
}

// Generate struct of projectile info (for server communication)
function generate_info_struct() {
	return {	// construct projectile info struct
		x: x, y: y,
		speed_x: speed_x,
		speed_y: speed_y,
		spin: spin,
		type: type
	}
}