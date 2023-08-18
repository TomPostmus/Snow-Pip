// Player properties
name = "new_player"
playid = -1

hp = 0
hp_prev = 0				// hp in previous step
hp_changed = false		// whether hp changed this step
respawn_timer = 0		// timer for respawning (count-down, 0 means timer elapsed, -1 means timer not set)

// Movement vars
x = 0
y = 0
rotation = 0

// Input vars
in_left = false
in_right = false
in_forward = false
in_backward = false

// Arms animation state
arm_state = ANIM_STATE.EMPTY

// Hitmask
hmask_head = noone
hmask_trunk = noone

// Damage player by hp amount _damage
function damage(_damage) {
	hp = max(hp - _damage, 0)							// subtract damage from hp, capping at 0
	
	// Die
	if (hp == 0) {
		respawn_timer = obj_game.respawn_time			// set respawn timer		
		
		with (hmask_head) instance_destroy()			// destroy hitmasks
		with (hmask_trunk) instance_destroy()
	}
}