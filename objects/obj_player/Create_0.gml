// Player attributes
local = false
name = ""
playid = -1											// id of player within current server session

pip = noone											// pip inst of current player

input = instance_create_layer(						// input inst of current player
	0, 0, "Instances", obj_input)
input.player = self									// give id to input inst

// Hp
hp = 0												// current hp (set by server) 
hp_prev = 0											// hp in previous step
hp_changed = 0										// whether hp has changed current step

// Spawn/despawn flags
spawn = false										// whether to spawn player (set by server)
despawn = false										// whether to despawn player (set by server)

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

// Received projectile creation from server
received_projectile_creation = false				// whether projectile creation packet has been received this step
received_projectile_info = {}						// struct containing info about projectile creation