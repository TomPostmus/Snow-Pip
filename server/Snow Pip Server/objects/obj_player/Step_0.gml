if (obj_game.state == GAME_STATE.GAME) {
	// Notify whether hp changed (for server)
	hp_changed = hp_prev != hp
	hp_prev = hp											// update hp_prev
	
	// Update respawn timer
	if (respawn_timer > 0) respawn_timer --
	
	// When alive
	if (hp > 0) {
		// Create hitmasks
		if (!instance_exists(hmask_head)) {
			hmask_head = instance_create_layer(x, y, "Instances", obj_hmask_head)
			hmask_head.player = self
			hmask_trunk = instance_create_layer(x, y, "Instances", obj_hmask_trunk)
			hmask_trunk.player = self
		}
	
		// Update hitmasks
		var _trunk_x = x + lengthdir_x(0, rotation)
		var _trunk_y = y + lengthdir_y(0, rotation)

		with (hmask_trunk) {
			x = _trunk_x; y = _trunk_y
			image_angle = other.rotation
		}

		var _head_x = x + lengthdir_x(7, rotation)
		var _head_y = y + lengthdir_y(7, rotation)

		with (hmask_head) {
			x = _head_x; y = _head_y
			image_angle = other.rotation
		}
	}
}