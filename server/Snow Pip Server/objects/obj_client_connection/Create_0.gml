client_players = ds_list_create() // player ids belonging to this client connection

// Read packet from this client connection
function read_packet(buffer) {
	var type = buffer_read(buffer, buffer_u8)
	switch (type) {
		case PACK.HELLO: read_hello(buffer); break
		case PACK.UPDATE_PLAYER: read_player_update(buffer); break
	}
}

// Send packet to client
function send_packet(buffer) {
	network_send_packet(socket, buffer, buffer_get_size(buffer))
	buffer_delete(buffer)
}

// Read packet of type HELLO
function read_hello(buffer) {
	var nr = buffer_read(buffer, buffer_u8) // nr of new players from client
	
	// read player names from packet and create player insts
	for (var i = 0; i < nr; i ++) {
		var player = instance_create_layer(0, 0,
			"Instances", obj_player)
			
		player.player_id = game.unique_player_id() // get a unique id for this player
			
		ds_list_add(client_players, player.player_id) // add new player to players list of current client connection		
	}
	
	send_hello() // immediately respond
	
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
		
		if (ds_list_find_index(client_players, pl_id) == -1) { // check if player belongs to client
			send_error(NETWORK_ERROR.INVALID_PLAYER_ID)
			return
		}
		
		var player = game.find_player(pl_id)
		
		player.name = buffer_read(buffer, buffer_string)
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
	//	buffer_write(buffer, buffer_u8, player_id)
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