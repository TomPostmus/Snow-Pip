socket = network_create_socket(network_socket_tcp)

// Try to connect
port = 3929
url = "127.0.0.1"
var connect = network_connect(socket, url, port)
while (connect < 0) {
	port ++
	connect = network_connect(socket, url, port)
}

// Send packet functions
function send_hello() {
	var buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, PACK.HELLO)
	buffer_write(buffer, buffer_u8, 
		instance_number(obj_player)) // write nr of players
		
	with (obj_player) { // for each player write their name
		buffer_write(buffer, buffer_string, name)
	}
	
	network_send_packet(socket, buffer, buffer_get_size(buffer))
	buffer_delete(buffer)
}

// Read packet from server
function read_packet(buffer) {
	var type = buffer_read(buffer, buffer_u8)
	switch (type) {
		case PACK.HELLO: read_hello(buffer)
	}
}

// Read HELLO response from server
function read_hello(buffer) {
	with (obj_player) {
		player_id = buffer_read(buffer, buffer_u8)
	}
	room_goto_next()
}

alarm[0] = 1 // set alarm for sending HELLO packet