client_players = ds_list_create() // player insts belonging to this client connection

// Read packet from this client connection
function read_packet(buffer) {
	var type = buffer_read(buffer, buffer_u8)
	switch (type) {
		case PACK.HELLO: read_hello(buffer)
	}
}

// Read packet of type HELLO and immediately respond
function read_hello(buffer) {
	var nr = buffer_read(buffer, buffer_u8) // nr of new players from client
	
	// create response buffer
	var resp_buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(resp_buffer, buffer_seek_start, 0)
	buffer_write(resp_buffer, buffer_u8, PACK.HELLO)
	
	// read player names from packet and create player insts
	for (var i = 0; i < nr; i ++) {
		var player = instance_create_layer(0, 0,
			"Instances", obj_player)
			
		player.name = buffer_read(buffer, buffer_string) // get name from packet
		player.player_id = game.unique_player_id() // get a unique id for this player
			
		ds_list_add(client_players, player) // add new player to players list of current client connection
		
		buffer_write(resp_buffer, buffer_u8, player.player_id) // add new player id to response
	}
	
	// send response
	network_send_packet(socket, resp_buffer, buffer_get_size(buffer))
	buffer_delete(resp_buffer)
}