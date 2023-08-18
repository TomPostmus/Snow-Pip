// Projectile vars
speed_x = 0						// fly speed
speed_y = 0
spin = false					// whether to fly with spin trajetory
type = ITEM.SNOWBALL			// what type of projectile
projectile_id = -1				// projectile id (used for communication of destroy)

// Spin trajectory
spin_radius = 240				// radius of spin trajectory
spin_init_dir = undefined		// initial direction of throw
spin_max_turn = 180				// maximum turn direction of trajectory

// Return a unique projectile id
function unique_projectile_id() {
	obj_game.next_projectile_id = 
		(obj_game.next_projectile_id + 1) mod 256	// increase projectile id and do modulo 256 (to stay within range of 1 byte, for network communication)
			
	return obj_game.next_projectile_id	
}