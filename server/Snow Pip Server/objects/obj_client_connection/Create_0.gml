// Client properties
name = ""

// Read packet from this client connection
function read_packet(buffer) {
	var type = buffer_read(buffer, buffer_u8)
	switch (type) {
		case PACK.HELLO: read_hello(buffer)
	}
}

// Read packet of type HELLO
function read_hello(buffer) {
	name = buffer_read(buffer, buffer_string)
}