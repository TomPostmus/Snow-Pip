// Open server
port = 3929
socket = network_create_server(network_socket_tcp, port, 64)
while (socket < 0) { // in case of error try different port num
	port ++
	socket = network_create_server(network_socket_tcp, port, 64)
}