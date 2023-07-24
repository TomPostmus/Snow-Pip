game = instance_create_layer(0, 0, // create game inst of server
	"Instances", obj_game)

// Open server
port = 3929
tcp_socket = network_create_server(network_socket_tcp, port, 64)
while (tcp_socket < 0) { // in case of error try different port num
	port ++
	tcp_socket = network_create_server(network_socket_tcp, port, 64)
}

// Client connection, create new client
function client_connect(client_socket) {
	var client = instance_create_layer(0, 0,
		"Instances", obj_client_connection
	)
	client.socket = client_socket
	client.game = game // pass game inst reference to client connection
	
	clients_game_update() // update all connected clients
}

// Client diconnecting, remove client
function client_disconnect(client_socket) {
	with (obj_client_connection) {
		if (socket == client_socket)
			instance_destroy()
	}
	
	clients_game_update() // update all connected clients
}

// Pass incoming tcp data to destined client connection
function incoming_tcp_data(client_socket, buffer) {
	with (obj_client_connection) {
		if (socket == client_socket)
			read_packet(buffer)
	}
}

// Call game update on each client connection
function clients_game_update() {
	with (obj_client_connection)
		send_game_update()
}