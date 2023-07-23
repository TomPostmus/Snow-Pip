// Handle incoming data
var in_socket = async_load[? "id"];
var in_type = async_load[? "type"];
var in_ip = async_load[? "ip"];

// Handle tcp connections
if (in_socket == tcp_socket) {
	switch (in_type) {
		case network_type_connect: 
			client_connect(async_load[? "socket"]);break
		case network_type_disconnect:
			client_disconnect(async_load[? "socket"]); break
			
	}
}

// Handle incoming data
if (in_type == network_type_data) {
	incoming_tcp_data(in_socket, async_load[? "buffer"]);
}