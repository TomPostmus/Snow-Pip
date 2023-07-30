socket = network_create_socket(network_socket_tcp)
game = instance_create_layer(0, 0, "Instances", obj_game) // local repr of game

// Connection state machine
connected = false
connect_state = "send_hello" // initial state
received_hello = false // whether hello response has been received (from async event)
received_game_update = false // whether game update has been received (from async event)

// Try to connect
port = 3929
url = "127.0.0.1"
var connect = network_connect(socket, url, port)
while (connect < 0) {
	port ++
	connect = network_connect(socket, url, port)
}

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
		buffer_write(buffer, buffer_u8, player_id)
		buffer_write(buffer, buffer_string, name)
	}
	
	network_send_packet(socket, buffer, buffer_get_size(buffer))
	buffer_delete(buffer)
}

// Read packet from server (called from async networking event)
function read_packet(buffer) {
	var type = buffer_read(buffer, buffer_u8)
	switch (type) {
		case PACK.HELLO: read_hello(buffer); break
		case PACK.UPDATE_GAME: read_game_update(buffer); break;
		case PACK.UPDATE_PLAYER: read_player_update(buffer) break;
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
	
	if (!connected) // if still in connection state machine
		received_game_update = true // notify state machine
	else {			// else handle immediately
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