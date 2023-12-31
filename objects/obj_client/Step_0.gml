// Handle packet queue in special states
if (connect_state == "await_hello") {					// if in await hello state, look specifically for HELLO packet
	for (var i = 0; i < ds_list_size(packets); i ++) {
		var _packet = packets[|i]
		buffer_seek(_packet, buffer_seek_start, 0)		// move to start position (for reading)
		var _type = buffer_read(_packet, buffer_u8)
		
		if (_type == PACK.HELLO) {						// found it!
			read_hello(_packet);						// process packet
			received_hello = true						// notify connect state machine
			ds_list_delete(packets, i); i--				// pop packet from queue
		}	
	}
	
} else if (connect_state == "await_game_update") {		// if in await hello state, look specifically for HELLO packet
	for (var i = 0; i < ds_list_size(packets); i ++) {
		var _packet = packets[|i]
		buffer_seek(_packet, buffer_seek_start, 0)		// move to start position (for reading)
		var _type = buffer_read(_packet, buffer_u8)
		var _type2 = buffer_peek(_packet, 0, buffer_u8)
		
		if (_type == PACK.UPDATE_GAME) {				// found it!
			read_game_update(_packet);					// process packet
			received_game_update = true					// notify connect state machine
			ds_list_delete(packets, i); i--				// pop packet from queue
		}	
	}

// Handle packet queue in normal connected state
} else if (connect_state == "connected") {

	// First look for game updates (since we may need to change room before handling other packets)
	var _found_game_update = false
	for (var i = 0; i < ds_list_size(packets); i ++) {
		var _packet = packets[|i]
		buffer_seek(_packet, buffer_seek_start, 0);		// move to start position (for reading)
		var _type = buffer_read(_packet, buffer_u8)
		
		if (_type == PACK.UPDATE_GAME) {				// found it!
			read_game_update(_packet);					// process packet
			_found_game_update = true					// set flag to true
			ds_list_delete(packets, i); i--				// pop packet from queue
		}	
	}
	
	// Look at other packets (or skip a step, to let room change occur)
	if (!_found_game_update) {
		for (var i = 0; i < ds_list_size(packets); i ++) {
			var _packet = packets[|i]
			buffer_seek(_packet, buffer_seek_start, 0)	// move to start position (for reading)
			var _type = buffer_read(_packet, buffer_u8)
		
			switch (_type) {
				case PACK.UPDATE_PLAYER: 
					read_player_update(_packet)
					ds_list_delete(packets, i); i--				// pop packet from queue
				break;
				case PACK.UPDATE_MOVEMENT: 
					read_movement_update(_packet) 
					ds_list_delete(packets, i); i--				// pop packet from queue
				break;
				case PACK.SPAWN_PLAYER: 
					read_spawn_player(_packet) 
					ds_list_delete(packets, i); i--				// pop packet from queue
				break;
				case PACK.UPDATE_ANIM: 
					read_animation_update(_packet) 
					ds_list_delete(packets, i); i--				// pop packet from queue
				break;
				case PACK.UPDATE_HP: 
					read_hp_update(_packet) 
					ds_list_delete(packets, i); i--				// pop packet from queue
				break;
				case PACK.PROJECTILE: 
					read_projectile_creation(_packet) 
					ds_list_delete(packets, i); i--				// pop packet from queue
				break;
				case PACK.PROJECTILE_ID: 
					read_projectile_id(_packet) 
					ds_list_delete(packets, i); i--				// pop packet from queue
				break;
				case PACK.PROJECTILE_HIT: 
					read_projectile_hit(_packet) 
					ds_list_delete(packets, i); i--				// pop packet from queue
				break;
			}
		}
	}
}

// Sequential client connection state machine
if (connect_state == "await_connection") {
	if (received_server_connection) {
		send_hello()						// send hello request
		connect_state = "await_hello"
	}
	
} else if (connect_state == "await_hello") {
	if (received_hello) {
		connect_state = "await_game_update"
	}
		
} else if (connect_state == "await_game_update") {
	if (received_game_update) {
		connect_state = "connected"			// end of connection state machine
		connected = true
		send_player_update()				// send information of local players
	}
}

// Game state
if (game.state == GAME_STATE.GAME) {
	// Send movement updates
	send_movement_timer --
	if (send_movement_timer <= 0) {
		send_movement_update() // send packet
		send_movement_timer = send_movement_period // reset timer
	}
	
	// Send arms animation update
	var _method = send_animation_update			// put function to call in local scope
	with (obj_player_local) {
		with (pip) {
			if (arm_state_changed)
				_method(other)					// call animation update packet function on player
		}
	}
	
	// Send projectile updates
	var _method = send_projectile_creation		// put function to call in local scope
	var _projectiles = projectile_queue			// put projectiles queue in local scope
	with (obj_player_local) {
		with (pip) {
			if (projectile_created) {
				_method(other, projectile_info)	// call projectile creation packet function with player and projectile info
				
				ds_queue_enqueue(				// enqueue projectile in projectiles queue for awaiting projectile id (from server)
					_projectiles, projectile)
				projectile_created = false		// reset flag
			}
		}
	}
}