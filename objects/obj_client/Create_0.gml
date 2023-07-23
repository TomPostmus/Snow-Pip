socket = network_create_socket(network_socket_tcp)
name = "Johannes" + string(irandom(100)) // random name

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
	buffer_write(buffer, buffer_string, name)
	
	network_send_packet(socket, buffer, buffer_get_size(buffer))
	buffer_delete(buffer)
}

send_hello()