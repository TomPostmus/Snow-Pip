/// @description connection timout

if (!received_server_connection) {
	network_connect_async(socket, url, port) // retry connection
	alarm[0] = connection_timeout
	
	show_debug_message("Connection timeout! Retrying...")
}