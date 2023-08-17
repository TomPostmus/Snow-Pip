var _in_socket = async_load[? "id"];
var _type = async_load[? "type"];

// Handle incoming data
if (_type == network_type_data) {
	// Put data into queue
	if (_in_socket == socket) {
		var _buffer = async_load[? "buffer"]				// load buffer
		var _size = buffer_get_size(_buffer)				// get size
		var _copy = buffer_create(_size, buffer_fixed, 1)	// make copy buffer
		buffer_copy(_buffer, 0, _size, _copy, 0)			// copy into copy buffer
		
		ds_list_add(packets, _copy)							// add copy to packet queue
		
		buffer_seek(_buffer, buffer_seek_start, 0)
		buffer_seek(_copy, buffer_seek_start, 0)
		var _type = buffer_read(_buffer, buffer_u8)
		var _type2 = buffer_read(_copy, buffer_u8)
		var size2 = buffer_get_size(_copy)
		var game_state = buffer_read(_buffer, buffer_u8)
		var game_state2 = buffer_read(_copy, buffer_u8)
		var nr = buffer_read(_buffer, buffer_u8)
		var nr2 = buffer_read(_copy, buffer_u8)
		
		ds_list_add(packet_log, _type)						// put type into packet log
	}
// Non-block connection
} else if (_type == network_type_non_blocking_connect) {
	received_server_connection = true
}