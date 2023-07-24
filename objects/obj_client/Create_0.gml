socket = network_create_socket(network_socket_tcp)

// Try to connect
port = 3929
url = "127.0.0.1"
var connect = network_connect(socket, url, port)
while (connect < 0) {
	port ++
	connect = network_connect(socket, url, port)
}

// Send HELLO packet with amount of local players
function send_hello(nr_players) {
	var buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, PACK.HELLO)
	buffer_write(buffer, buffer_u8, nr_players) // write nr of players
	
	network_send_packet(socket, buffer, buffer_get_size(buffer))
	buffer_delete(buffer)
}

// Send packet containing (non-realtime) player info
function send_player_update() {

}

// Read packet from server
function read_packet(buffer) {
	var type = buffer_read(buffer, buffer_u8)
	switch (type) {
		case PACK.HELLO: read_hello(buffer)
		case PACK.UPDATE_GAME: read_game_update(buffer)
	}
}

// Read HELLO response from server
function read_hello(buffer) {
	var nr = buffer_read(buffer, buffer_u8)
	
	// create local players
	for (var i = 0; i < nr; i ++) {
		var player = instance_create_layer(0, 0,
			"Instances", obj_player)
	
		player.local = true
		player.player_id = buffer_read(buffer, buffer_u8) // read player id from packet
	}
}

// Read game update packet
function read_game_update(buffer) {
	game.state = buffer_read(buffer, buffer_u8) // read game state
	
	var nr = buffer_read(buffer, buffer_u8) // read number of players
	
	for (var i = 0; i < nr; i ++) {
		var player_id = buffer_read(buffer, buffer_u8)
		var name = buffer_read(buffer, buffer_string)
		
		
	}
}

game = instance_create_layer(0, 0, "Instances", obj_game) // local repr of game
send_hello(2) // send hello with requesting 2 players