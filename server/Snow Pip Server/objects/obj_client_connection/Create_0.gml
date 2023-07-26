client_players = ds_list_create() // player insts belonging to this client connection

// Read packet from this client connection
function read_packet(buffer) {
	var type = buffer_read(buffer, buffer_u8)
	switch (type) {
		case PACK.HELLO: read_hello(buffer)
		case PACK.UPDATE_PLAYER: read_player_update(buffer)
	}
}

// Read packet of type HELLO
function read_hello(buffer) {
	var nr = buffer_read(buffer, buffer_u8) // nr of new players from client
	
	// read player names from packet and create player insts
	for (var i = 0; i < nr; i ++) {
		var player = instance_create_layer(0, 0,
			"Instances", obj_player)
			
		player.player_id = game.unique_player_id() // get a unique id for this player
			
		ds_list_add(client_players, player) // add new player to players list of current client connection		
	}
	
	send_hello() // immediately respond
	send_game_update() // also immediately send game update
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
		var player = client_players[|i]
		
		buffer_write(buffer, buffer_u8, player.player_id) // add player id to response
	}
	
	// send packet to client
	network_send_packet(socket, buffer, buffer_get_size(buffer))
	buffer_delete(buffer)
}

// Send packet with game update info
function send_game_update() {
	// create buffer
	var buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, PACK.UPDATE_GAME)
	
	buffer_write(buffer, buffer_u8, game.state) // write game state
	buffer_write(buffer, buffer_u8, instance_number(obj_player)) // nr of players
	
	// put id of each player
	with (obj_player) {
		buffer_write(buffer, buffer_u8, player_id)
	}
	
	// send packet to client
	network_send_packet(socket, buffer, buffer_get_size(buffer))
	buffer_delete(buffer)
}

// Read packet with player information
function read_player_update(buffer) {

}

// Send packet with player information
function send_player_update() {
	// create buffer
	var buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, PACK.UPDATE_PLAYER)
	
	buffer_write(buffer, buffer_u8, instance_number(obj_player)) // nr of players
	
	// put id of each player
	with (obj_player) {
		buffer_write(buffer, buffer_string, name)
	}
	
	// send packet to client
	network_send_packet(socket, buffer, buffer_get_size(buffer))
	buffer_delete(buffer)
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