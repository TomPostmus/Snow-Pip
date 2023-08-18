client_players = ds_list_create() // player ids belonging to this client connection

// Read packet from this client connection
function read_packet(buffer) {
	var type = buffer_read(buffer, buffer_u8)
	switch (type) {
		case PACK.HELLO: read_hello(buffer); break
		case PACK.UPDATE_PLAYER: read_player_update(buffer); break
		case PACK.UPDATE_MOVEMENT: read_movement_update(buffer); break
		case PACK.UPDATE_ANIM: read_animation_update(buffer); break
		case PACK.PROJECTILE: read_projectile_creation(buffer); break
	}
}

// Send packet to client
function send_packet(buffer) {
	network_send_packet(socket, buffer, buffer_get_size(buffer))
	buffer_delete(buffer)
}

// Send client all cath-up information about game (game-state, alive players etc.)
function catch_up() {
	// Send game update
	send_packet(server.packgen_game_update())	// send game update
		
	if (game.state == GAME_STATE.GAME) {
		// Send alive players
		with (obj_player) {
			if (hp > 0) {
				other.send_packet(		// send spawn player packet
					other.server.packgen_spawn_player(self))
			}
		}
	}
}

// Read packet of type HELLO
function read_hello(buffer) {
	var nr = buffer_read(buffer, buffer_u8) // nr of new players from client
	
	// read player names from packet and create player insts
	for (var i = 0; i < nr; i ++) {
		var player = instance_create_layer(0, 0,
			"Instances", obj_player)
			
		player.playid = game.unique_playid() // get a unique id for this player
			
		ds_list_add(client_players, player.playid) // add new player to players list of current client connection		
	}
	
	send_hello() // immediately respond
	
	// notify server that we want to catch up with client (this is not done here (in Async event) due to concurrency issues)
	ds_list_add(server.catch_up_clients, self)
	
	// notify server to broadcast game update (containing info of new players)
	server.broadcast_game_update = true
}

// Send HELLO packet with unique player ids of client
function send_hello() {
	var nr = ds_list_size(client_players)
	
	// create response buffer
	var buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, PACK.HELLO)
	buffer_write(buffer, buffer_u8, nr) // put nr of players in response
	
	// add player ids of this client
	for (var i = 0; i < nr; i ++) {
		var pl_id = client_players[|i]
		
		buffer_write(buffer, buffer_u8, pl_id) // add player id to response
	}
	
	send_packet(buffer)
}

// Read packet with player information
function read_player_update(buffer) {
	var nr = buffer_read(buffer, buffer_u8) // nr of new players from client
	
	// read player names from packet and set information
	for (var i = 0; i < nr; i ++) {
		var pl_id = buffer_read(buffer, buffer_u8)
		var name = buffer_read(buffer, buffer_string)
		
		if (ds_list_find_index(client_players, pl_id) == -1) { // check if player belongs to client
			send_error(NETWORK_ERROR.INVALID_PLAYID)
			return
		}
		
		var player = game.find_player(pl_id)
		
		player.name = name
	}
	
	// notify server to broadcast player update
	server.broadcast_player_update = true
}

// Send packet with movement update of each client
function send_movement_update() {
	// create buffer
	//var buffer = buffer_create(256, buffer_grow, 1)
	//buffer_seek(buffer, buffer_seek_start, 0)
	//buffer_write(buffer, buffer_u8, PACK.UPDATE_MOVEMENT)
	
	//buffer_write(buffer, buffer_u8, instance_number(obj_player)) // nr of players
	
	//// put info of each player
	//with (obj_player) {
	//	buffer_write(buffer, buffer_u8, playid)
	//	buffer_write(buffer, buffer_string, name)
	//}
}

// Send packet with server error
function send_error(error_code) {
	// create buffer
	var buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, PACK.ERROR)
	buffer_write(buffer, buffer_u8, error_code)
	
	// send packet to client
	network_send_packet(socket, buffer, buffer_get_size(buffer))
	buffer_delete(buffer)
}

// Read packet with player movement
function read_movement_update(buffer) {
	var nr = buffer_read(buffer, buffer_u8) // nr of players for which update applies
	
	// read player names from packet and set information
	for (var i = 0; i < nr; i ++) {
		var pl_id = buffer_read(buffer, buffer_u8) // read player id
		
		var _x = buffer_read(buffer, buffer_f16) // read coordinates
		var _y = buffer_read(buffer, buffer_f16) 
		var _rot = buffer_read(buffer, buffer_f16)
		
		var _in_left = buffer_read(buffer, buffer_bool) // read movement input
		var _in_right = buffer_read(buffer, buffer_bool)
		var _in_forward = buffer_read(buffer, buffer_bool)
		var _in_backward = buffer_read(buffer, buffer_bool)
		
		if (ds_list_find_index(client_players, pl_id) == -1) { // check if player belongs to client
			send_error(NETWORK_ERROR.INVALID_PLAYID)
			return
		}
		
		var player = game.find_player(pl_id)
		
		// Update player position
		if (player.hp > 0) { // check if player is alive
			player.x = _x
			player.y = _y
			player.rotation = _rot
			player.in_left = _in_left
			player.in_right = _in_right
			player.in_forward = _in_forward
			player.in_backward = _in_backward
		}
	}
}

// Read animation update packet
function read_animation_update(_buffer) {
	var _pl_id = buffer_read(_buffer, buffer_u8)				// read player id
	var _arm_state = buffer_read(_buffer, buffer_u8)			// read animation state

	var _player = game.find_player(_pl_id)
	
	_player.arm_state = _arm_state
	
	// notify server to broadcast animation update
	ds_list_add(server.broadcast_anim_update, [self, _player])	// put tuple of this client connection and player in question
}

// Read projectile creation packet
function read_projectile_creation(_buffer) {
	var _pl_id = buffer_read(_buffer, buffer_u8)				// read player id
	
	var _x = buffer_read(_buffer, buffer_f16)
	var _y = buffer_read(_buffer, buffer_f16)
	var _speed_x = buffer_read(_buffer, buffer_f16)
	var _speed_y = buffer_read(_buffer, buffer_f16)
	var _spin = buffer_read(_buffer, buffer_bool)
	var _type = buffer_read(_buffer, buffer_u8)
	
	var _player = game.find_player(_pl_id)
	
	var _projectile = instance_create_layer(					// create projectile
		_x, _y, "Instances", obj_projectile
	)
	_projectile.own_player = _player							// assign player obj (in order to avoid hitting itself)
	
	_projectile.playid = _pl_id									// assign playid
	
	_projectile.projectile_id =									// assign unique projectile id
		_projectile.unique_projectile_id()
		
	_projectile.speed_x = _speed_x								// assign other properties
	_projectile.speed_y = _speed_y
	_projectile.spin = _spin
	_projectile.type = _type	
	
	// immediately respond with unique projectile id
	send_projectile_id(_projectile)
	
	// notify server to broadcast projectile creation
	ds_list_add(server.broadcast_projectiles, [self, _projectile])
}

// Send packet with unique projectile id
function send_projectile_id(_projectile) {	
	// create response buffer
	var _buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(_buffer, buffer_seek_start, 0)
	buffer_write(_buffer, buffer_u8, PACK.PROJECTILE_ID)
	
	buffer_write(_buffer, buffer_u8,
		_projectile.projectile_id)								// put projectile id
	
	// send packet to client
	network_send_packet(socket, _buffer, buffer_get_size(_buffer))
	buffer_delete(_buffer)
}