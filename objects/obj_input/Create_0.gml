external_input = false // whether this is external input from online player

player = noone // player inst to which give input

// Find relative player id
relative_player_id = 0 // indicates relative player id of this input (without knowing actual player id from server)
while (instance_find(obj_input, relative_player_id) != id)
	relative_player_id ++