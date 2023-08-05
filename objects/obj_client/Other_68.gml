var in_socket = async_load[? "id"];
var type = async_load[? "type"];

// Handle incoming data
if (type == network_type_data) {
	if (in_socket == socket) {
		read_packet(async_load[? "buffer"])
	}
// Non-block connection
} else if (type == network_type_non_blocking_connect) {
	received_server_connection = true
}