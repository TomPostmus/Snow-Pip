local = false
name = ""
player_id = -1 // id of player within current server session

pip = noone // pip inst of current player

// Spawn flag
spawn = false // whether to spawn player (set from async network event)
spawn_x = 0 // location where to spawn
spawn_y = 0
spawn_rotation = 0

// Next position (received from server)
next_position = false // whether next pos has been received
next_x = 0 // next position
next_y = 0
next_rot = 0