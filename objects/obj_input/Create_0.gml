player = noone // player inst to which give input

// Input vars
axial = 0
lateral = 0
mouse_left = 0 // hold left
mouse_left_press = 0
mouse_left_release = 0
mouse_right = 0 // hold right
mouse_right_press = 0
mouse_right_release = 0

// Find relative player id
relative_player_id = 0 // indicates relative player id of this input (without knowing actual player id from server)
while (instance_find(obj_input, relative_player_id) != id)
	relative_player_id ++