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
	}
// Non-block connection
} else if (_type == network_type_non_blocking_connect) {
	received_server_connection = true
}