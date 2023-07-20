socket = network_create_socket(network_socket_tcp)

// Try to connect
port = 3929
url = "127.0.0.1"
var connect = network_connect(socket, url, port)
while (connect < 0) {
	port ++
	connect = network_connect(socket, url, port)
}