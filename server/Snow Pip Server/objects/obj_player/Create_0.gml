// Player properties
name = "new_player"
playid = -1

hp = 0
respawn_timer = 0		// timer for respawning (count-down, 0 means timer elapsed)

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