game = instance_create_layer(0, 0, // create game inst of server
	"Instances", obj_game)
game.server = self

// Broadcasting flags
broadcast_game_update = false
broadcast_player_update = false
broadcast_movement_update = false
broadcast_anim_update = ds_list_create() // list of clients of which we want to broadcast arms animation update

catch_up_clients = ds_list_create() // list of clients that we want to catch up with next step (set from async event)

// Game state machine
start_state = false

// Broadcasting player movement timer
broadcast_movement_period = 1 // after how many steps to send player movement to server
broadcast_movement_timer = 0 // timer to send movement update

// Open server
port = 3929
tcp_socket = network_create_server(network_socket_tcp, port, 64)
if (tcp_socket < 0) { // in case of error 
	throw "Server could not be opened (check if port "+ string(port) +" is free)."
}

// Client connection, create new client
function client_connect(client_socket) {
	var client = instance_create_layer(0, 0,
		"Instances", obj_client_connection
	)
	client.socket = client_socket
	client.server = self // pass reference to this server inst to client connection
	client.game = game // pass game inst reference to client connection
}

// Client diconnecting, remove client
function client_disconnect(client_socket) {
	with (obj_client_connection) {
		if (socket == client_socket)
			instance_destroy()
	}
	
	// notify broadcasting service
	broadcast_game_update = true // broadcast client departure
}

// Pass incoming tcp data to destined client connection
function incoming_tcp_data(client_socket, buffer) {
	with (obj_client_connection) {
		if (socket == client_socket)
			read_packet(buffer)
	}
}

// Broadcast packet to all client connections
function broadcast_packet(buffer) {
	var _except = argument[1]	// optional argument, used for excepting a client connection from broadcast
	
	with (obj_client_connection) {
		if (is_undefined(_except) || _except != self) // check if this client connection is exception
			network_send_packet(socket, buffer, buffer_get_size(buffer))
	}
	buffer_delete(buffer)
}

// Server packet generators //

// Generate game update packet
function packgen_game_update() {
	// create buffer
	var buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, PACK.UPDATE_GAME)
	
	buffer_write(buffer, buffer_u8, game.state) // write game state
	buffer_write(buffer, buffer_u8, instance_number(obj_player)) // nr of players
	
	// put id of each player
	with (obj_player) {
		buffer_write(buffer, buffer_u8, playid)
	}
	
	return buffer
}

// Generate player update package
function packgen_player_update() {
	// create buffer
	var buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, PACK.UPDATE_PLAYER)
	
	buffer_write(buffer, buffer_u8, instance_number(obj_player)) // nr of players
	
	// put id of each player and then info
	with (obj_player) {
		buffer_write(buffer, buffer_u8, playid)
		buffer_write(buffer, buffer_string, name)
	}
	
	return buffer
}

// Generate movement update package
function packgen_movement_update(player) {
	// create buffer
	var buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, PACK.UPDATE_MOVEMENT)
	
	var nr_players = 0
	with (obj_player) { // check how many are alive
		if (hp > 0)	nr_players ++
	}
	
	buffer_write(buffer, buffer_u8, nr_players) // write nr of alive players
	
	with (obj_player) { // write coordinates of live players
		if (hp > 0) {
			buffer_write(buffer, buffer_u8, playid) // write player id
			buffer_write(buffer, buffer_f16, x) // write coordinates (and rotation)
			buffer_write(buffer, buffer_f16, y)
			buffer_write(buffer, buffer_f16, rotation)
			
			buffer_write(buffer, buffer_bool, in_left) // write movement input
			buffer_write(buffer, buffer_bool, in_right)
			buffer_write(buffer, buffer_bool, in_forward)
			buffer_write(buffer, buffer_bool, in_backward)
		}
	}
	
	return buffer
}

// Generate spawn package of player (at its x y coordinates)
function packgen_spawn_player(player) {
	// create buffer
	var buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, PACK.SPAWN_PLAYER)
	
	buffer_write(buffer, buffer_u8, player.playid) // write player id
	buffer_write(buffer, buffer_f16, player.x) // write player x coordinate
	buffer_write(buffer, buffer_f16, player.y) // write player y coordinate
	buffer_write(buffer, buffer_f16, player.rotation) // write player rotation
	
	return buffer
}

// Generate animation update packet of player
function packgen_animation_update(_player) {
	// create buffer
	var _buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(_buffer, buffer_seek_start, 0)
	buffer_write(_buffer, buffer_u8, PACK.UPDATE_ANIM)
	
	buffer_write(_buffer, buffer_u8, _player.playid)			// write playid
	buffer_write(_buffer, buffer_u8, _player.arm_state)			// write animation state
	
	return _buffer
}