// Player attributes
local = false
name = ""
playid = -1 // id of player within current server session

pip = noone // pip inst of current player

input = instance_create_layer(0, 0, "Instances", obj_input)
input.player = self

// Hp
hp = 0

// Spawn flag
spawn = false // whether to spawn player (set from async network event)

// Received position from server, used for spawning player as well as updating position
received_x = 0
received_y = 0
received_rot = 0

// Received input from server
received_in_left = false
received_in_right = false
received_in_forward = false
received_in_backward = false

// Received arms animation state from server
received_arm_state = ANIM_STATE.EMPTY