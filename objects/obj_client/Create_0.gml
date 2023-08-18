socket = network_create_socket(network_socket_tcp)
game = instance_create_layer(0, 0, "Instances", obj_game) // local repr of game

// Connection state machine
connected = false							// whether connection state machine is fully completed
connect_state = "await_connection"			// initial state
received_hello = false						// whether hello response has been received (from async event)
received_game_update = false				// whether game update has been received (from async event)
received_server_connection = false			// whether initial connection w server has been established

// Try to connect
port = 3929
url = "127.0.0.1"
network_connect_async(socket, url, port)	// try non-blocking connection (see async network event for callback)
connection_timeout = 300					// connection timeout of 5 seconds
alarm[0] = connection_timeout				// set connection timeout alarm

// Packet queue
packets = ds_list_create()					// list of received packets (representing packet queue) 
packet_log = ds_list_create()				// list of packet types received (for logging purpose)	

// Player movement updates sending
send_movement_period = 1					// after how many steps to send player movement to server
send_movement_timer = 0						// timer to send movement update

// Projectiles
projectile_queue = ds_queue_create()		// queue of projectiles (created by local players) that await a projectile_id given to them (by server)

// Send HELLO packet with amount of local players
function send_hello() {
	var nr_players = instance_number(obj_player_local)
	
	var _buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(_buffer, buffer_seek_start, 0)
	buffer_write(_buffer, buffer_u8, PACK.HELLO)
	buffer_write(_buffer, buffer_u8, nr_players) // write nr of players
	
	network_send_packet(socket, _buffer, buffer_get_size(_buffer))
	buffer_delete(_buffer)
}

// Send packet containing (non-realtime) player info
function send_player_update() {
	var nr_players = instance_number(obj_player_local)
	
	var _buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(_buffer, buffer_seek_start, 0)
	buffer_write(_buffer, buffer_u8, PACK.UPDATE_PLAYER)
	buffer_write(_buffer, buffer_u8, nr_players) // write nr of players
	
	// put id of each player and then info
	with (obj_player_local) {
		buffer_write(_buffer, buffer_u8, playid)
		buffer_write(_buffer, buffer_string, name)
	}
	
	network_send_packet(socket, _buffer, buffer_get_size(_buffer))
	buffer_delete(_buffer)
}

// Send player movement packet containing movement info of local players
function send_movement_update() {
	// nr of players that are alive
	var nr_players = 0
	with (obj_player_local) {
		if (instance_exists(pip))
			nr_players ++
	}
	
	var _buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(_buffer, buffer_seek_start, 0)
	buffer_write(_buffer, buffer_u8, PACK.UPDATE_MOVEMENT)
	buffer_write(_buffer, buffer_u8, nr_players) // write nr of players
	
	// put id of each player and movement and input
	with (obj_player_local) {
		if (instance_exists(pip)) {
			buffer_write(_buffer, buffer_u8, playid)
			buffer_write(_buffer, buffer_f16, pip.collision.x)
			buffer_write(_buffer, buffer_f16, pip.collision.y)
			buffer_write(_buffer, buffer_f16, pip.rotation)
			
			buffer_write(_buffer, buffer_bool, input.left) // write movement input
			buffer_write(_buffer, buffer_bool, input.right)
			buffer_write(_buffer, buffer_bool, input.forward)
			buffer_write(_buffer, buffer_bool, input.backward)
		}
	}
	
	network_send_packet(socket, _buffer, buffer_get_size(_buffer))
	buffer_delete(_buffer)
}

// Send animation update packet of player
function send_animation_update(_player) {
	var _buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(_buffer, buffer_seek_start, 0)
	buffer_write(_buffer, buffer_u8, PACK.UPDATE_ANIM)
	
	buffer_write(_buffer, buffer_u8, _player.playid)			// write playid
	buffer_write(_buffer, buffer_u8, _player.pip.arm_state)		// write animation state
	
	network_send_packet(socket, _buffer, buffer_get_size(_buffer))
	buffer_delete(_buffer)
}

// Send projectile update packet of player
function send_projectile_creation(_player, _projectile_info) {
	var _buffer = buffer_create(256, buffer_grow, 1)
	buffer_seek(_buffer, buffer_seek_start, 0)
	buffer_write(_buffer, buffer_u8, PACK.PROJECTILE)
	
	buffer_write(_buffer, buffer_u8, _player.playid)			// write playid
	
	buffer_write(_buffer, buffer_f16, _projectile_info.x)		// write projectile info
	buffer_write(_buffer, buffer_f16, _projectile_info.y)
	buffer_write(_buffer, buffer_f16, _projectile_info.speed_x)
	buffer_write(_buffer, buffer_f16, _projectile_info.speed_y)
	buffer_write(_buffer, buffer_bool, _projectile_info.spin)
	buffer_write(_buffer, buffer_u8, _projectile_info.type)
	
	network_send_packet(socket, _buffer, buffer_get_size(_buffer))
	buffer_delete(_buffer)
}

// Read HELLO response from server
function read_hello(_buffer) {
	var _nr = buffer_read(_buffer, buffer_u8)
	
	// read player ids and put into local players list
	ds_list_clear(game.local_players)
	for (var i = 0; i < _nr; i ++) {
		var _pl_id = buffer_read(_buffer, buffer_u8)	// read player id from packet
		ds_list_add(game.local_players, _pl_id)			// add to local players list
	}
	
	buffer_delete(_buffer)								// delete buffer
}

// Read game update packet
function read_game_update(_buffer) {	
	game.state = buffer_read(_buffer, buffer_u8) // read game state
	
	var _nr = buffer_read(_buffer, buffer_u8) // read number of players
	
	// read player ids and put into players list
	ds_list_clear(game.players)
	for (var i = 0; i < _nr; i ++) {
		var _pl_id = buffer_read(_buffer, buffer_u8) // read player id from packet
		ds_list_add(game.players, _pl_id) // add to players list		
	}
	
	game.update_player_list()	// update player list
	game.switch_room()			// switch room (if applicable)
	
	buffer_delete(_buffer)								// delete buffer
}

// Read player update packet
function read_player_update(_buffer) {	
	var _nr = buffer_read(_buffer, buffer_u8) // read number of players
	
	// For each player update info
	for (var i = 0; i < _nr; i ++) {
		var _pl_id = buffer_read(_buffer, buffer_u8) // read player id from packet
		var _name = buffer_read(_buffer, buffer_string) // read player name from packet
		
		var _player = game.find_player(_pl_id)
		
		_player.name = _name // update name
	}
	
	buffer_delete(_buffer)								// delete buffer
}

// Read player update packet
function read_movement_update(_buffer) {
	var _nr = buffer_read(_buffer, buffer_u8) // read number of players
	
	// For each player update coordinates
	for (var i = 0; i < _nr; i ++) {
		var _pl_id = buffer_read(_buffer, buffer_u8) // read player id from packet
		
		var _x = buffer_read(_buffer, buffer_f16) // read coordinates
		var _y = buffer_read(_buffer, buffer_f16) 
		var _rot = buffer_read(_buffer, buffer_f16)
		
		var _in_left = buffer_read(_buffer, buffer_bool) // read movement input
		var _in_right = buffer_read(_buffer, buffer_bool)
		var _in_forward = buffer_read(_buffer, buffer_bool)
		var _in_backward = buffer_read(_buffer, buffer_bool)
		
		var _player = game.find_player(_pl_id)
		
		with (_player) {
			received_x = _x
			received_y = _y
			received_rot = _rot
			received_in_left = _in_left
			received_in_right = _in_right
			received_in_forward = _in_forward
			received_in_backward = _in_backward
		}
	}
	
	buffer_delete(_buffer)								// delete buffer
}

// Read player spawn packet
function read_spawn_player(_buffer) {
	var _pl_id = buffer_read(_buffer, buffer_u8) // read player id of player to spawn
	
	var _x = buffer_read(_buffer, buffer_f16) // read coordinates
	var _y = buffer_read(_buffer, buffer_f16) 
	var _rot = buffer_read(_buffer, buffer_f16)
	
	var _player = game.find_player(_pl_id)
	
	// notify player of spawning
	with (_player) {
		spawn = true
		received_x = _x
		received_y = _y
		received_rot = _rot
	}
	
	buffer_delete(_buffer)								// delete buffer
}

// Read animation update
function read_animation_update(_buffer) {
	var _pl_id = buffer_read(_buffer, buffer_u8)		// read player id of player to spawn
	var _arm_state = buffer_read(_buffer, buffer_u8)	// read new arms animation state
	
	var _player = game.find_player(_pl_id)
	
	// update state
	with (_player) {
		received_arm_state = _arm_state
	}
	
	buffer_delete(_buffer)								// delete buffer
}

// Read projectile creation packet
function read_projectile_creation(_buffer) {
	var _pl_id = buffer_read(_buffer, buffer_u8)		// read player id to which projectile belongs
	
	var _proj_id = buffer_read(_buffer, buffer_u8)		// read unique projectile id of this projectile
	
	var _x = buffer_read(_buffer, buffer_f16)			// read projectile info
	var _y = buffer_read(_buffer, buffer_f16)
	var _speed_x = buffer_read(_buffer, buffer_f16)
	var _speed_y = buffer_read(_buffer, buffer_f16)
	var _spin = buffer_read(_buffer, buffer_bool)
	var _type = buffer_read(_buffer, buffer_u8)
	
	var _player = game.find_player(_pl_id)
	
	// notify player
	with (_player) {
		received_projectile_creation = true
		received_projectile_info = {					// give info on projectile to be created
			x: _x, 
			y: _y,
			speed_x: _speed_x,
			speed_y: _speed_y,
			spin: _spin,
			type: _type,
			projectile_id: _proj_id
		}
	}
}

// Read projectile id packet
function read_projectile_id(_buffer) {
	var _projectile_id = buffer_read(_buffer, buffer_u8)	// read projectile id
	
	var _projectile = ds_queue_dequeue(projectile_queue)	// dequeue projectile
	
	if (!is_undefined(_projectile))
		_projectile.projectile_id = _projectile_id			// asssign id
		
	buffer_delete(_buffer)									// delete buffer
}