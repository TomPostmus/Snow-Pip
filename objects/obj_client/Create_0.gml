socket = network_create_socket(network_socket_tcp)
game = instance_create_layer(0, 0, "Instances", obj_game) // local repr of game

// Player movement updates sending
send_movement_period = 1 // after how many steps to send player movement to server
send_movement_timer = 0 // timer to send movement update

// Connection state machine
connected = false // whether connection state machine is fully completed
connect_state = "await_connection" // initial state
received_hello = false // whether hello response has been received (from async event)
received_game_update = false // whether game update has been received (from async event)
received_server_connection = false // whether initial connection w server has been established

// Try to connect
port = 3929
url = "127.0.0.1"
network_connect_async(socket, url, port) // try non-blocking connection (see async network event for callback)
connection_timeout = 300 // connection timeout of 5 seconds
alarm[0] = connection_timeout // set connection timeout alarm

// Send HELLO packet with amount of local players
function send_hello() {
	var nr_players = instance_number(obj_player_local)
	
	var buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, PACK.HELLO)
	buffer_write(buffer, buffer_u8, nr_players) // write nr of players
	
	network_send_packet(socket, buffer, buffer_get_size(buffer))
	buffer_delete(buffer)
}

// Send packet containing (non-realtime) player info
function send_player_update() {
	var nr_players = instance_number(obj_player_local)
	
	var buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, PACK.UPDATE_PLAYER)
	buffer_write(buffer, buffer_u8, nr_players) // write nr of players
	
	// put id of each player and then info
	with (obj_player_local) {
		buffer_write(buffer, buffer_u8, playid)
		buffer_write(buffer, buffer_string, name)
	}
	
	network_send_packet(socket, buffer, buffer_get_size(buffer))
	buffer_delete(buffer)
}

// Send player movement packet
function send_movement_update() {
	// nr of players that are alive
	var nr_players = 0
	with (obj_player_local) {
		if (instance_exists(pip))
			nr_players ++
	}
	
	var buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, PACK.UPDATE_MOVEMENT)
	buffer_write(buffer, buffer_u8, nr_players) // write nr of players
	
	// put id of each player and movement and input
	with (obj_player_local) {
		if (instance_exists(pip)) {
			buffer_write(buffer, buffer_u8, playid)
			buffer_write(buffer, buffer_f16, pip.collision.x)
			buffer_write(buffer, buffer_f16, pip.collision.y)
			buffer_write(buffer, buffer_f16, pip.rotation)
			
			buffer_write(buffer, buffer_bool, input.left) // write movement input
			buffer_write(buffer, buffer_bool, input.right)
			buffer_write(buffer, buffer_bool, input.forward)
			buffer_write(buffer, buffer_bool, input.backward)
		}
	}
	
	network_send_packet(socket, buffer, buffer_get_size(buffer))
	buffer_delete(buffer)
}

// Read packet from server (called from async networking event)
function read_packet(buffer) {
	var type = buffer_read(buffer, buffer_u8)
	if (connected) {
		switch (type) {
			case PACK.HELLO: read_hello(buffer); break;
			case PACK.UPDATE_GAME: read_game_update(buffer); break;
			case PACK.UPDATE_PLAYER: read_player_update(buffer) break;
			case PACK.UPDATE_MOVEMENT: read_movement_update(buffer) break;
			case PACK.SPAWN_PLAYER: read_spawn_player(buffer) break;
		}
	} else { // if still in connection state machine, we do not act on other packets
		switch (type) {
			case PACK.HELLO: read_hello(buffer); break;
			case PACK.UPDATE_GAME: read_game_update(buffer); break;
		}
	}
}

// Read HELLO response from server
function read_hello(buffer) {
	var nr = buffer_read(buffer, buffer_u8)
	
	// read player ids and put into local players list
	ds_list_clear(game.local_players)
	for (var i = 0; i < nr; i ++) {
		var pl_id = buffer_read(buffer, buffer_u8) // read player id from packet
		ds_list_add(game.local_players, pl_id) // add to local players list
	}
	
	received_hello = true // notify connect state machine
}

// Read game update packet
function read_game_update(buffer) {
	game.state = buffer_read(buffer, buffer_u8) // read game state
	
	var nr = buffer_read(buffer, buffer_u8) // read number of players
	
	// read player ids and put into players list
	ds_list_clear(game.players)
	for (var i = 0; i < nr; i ++) {
		var pl_id = buffer_read(buffer, buffer_u8) // read player id from packet
		ds_list_add(game.players, pl_id) // add to players list		
	}
	
	if (!connected) {// if still in connection state machine
		var contained = true // whether local players are contained in player list
		for (var i = 0; i < ds_list_size(game.local_players); i ++) {
			var pl_id = game.local_players[|i]
			if (ds_list_find_index(game.players, pl_id) == -1)
				contained = false
		}		
		
		if (contained && received_hello) // check that game update contains local players (or is maybe outdated)
			received_game_update = true // notify state machine
	} else {			// else handle immediately
		game.switch_room()			// switch room (if applicable)
		game.update_player_list()	// update player list
	}
}

// Read player update packet
function read_player_update(buffer) {	
	var nr = buffer_read(buffer, buffer_u8) // read number of players
	
	// For each player update info
	for (var i = 0; i < nr; i ++) {
		var pl_id = buffer_read(buffer, buffer_u8) // read player id from packet
		var name = buffer_read(buffer, buffer_string) // read player name from packet
		
		var player = game.find_player(pl_id)
		
		player.name = name // update name
	}	
}

// Read player update packet
function read_movement_update(buffer) {
	var nr = buffer_read(buffer, buffer_u8) // read number of players
	
	// For each player update coordinates
	for (var i = 0; i < nr; i ++) {
		var pl_id = buffer_read(buffer, buffer_u8) // read player id from packet
		
		var _x = buffer_read(buffer, buffer_f16) // read coordinates
		var _y = buffer_read(buffer, buffer_f16) 
		var _rot = buffer_read(buffer, buffer_f16)
		
		var _in_left = buffer_read(buffer, buffer_bool) // read movement input
		var _in_right = buffer_read(buffer, buffer_bool)
		var _in_forward = buffer_read(buffer, buffer_bool)
		var _in_backward = buffer_read(buffer, buffer_bool)
		
		var player = game.find_player(pl_id)
		
		with (player) {
			received_x = _x
			received_y = _y
			received_rot = _rot
			received_in_left = _in_left
			received_in_right = _in_right
			received_in_forward = _in_forward
			received_in_backward = _in_backward
		}
	}
}

// Read player spawn packet
function read_spawn_player(buffer) {
	var pl_id = buffer_read(buffer, buffer_u8) // read player id of player to spawn
	
	var _x = buffer_read(buffer, buffer_f16) // read coordinates
	var _y = buffer_read(buffer, buffer_f16) 
	var _rot = buffer_read(buffer, buffer_f16)
	
	var player = game.find_player(pl_id)
	
	// read spawn location
	with (player) {
		spawn = true
		received_x = _x
		received_y = _y
		received_rot = _rot
	}
}