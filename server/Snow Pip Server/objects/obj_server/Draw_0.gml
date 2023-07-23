var i = 0
with (obj_player) {
	if (player_id != undefined) {
		var str = name + ": " + string(player_id)
		draw_text(20, 20 + i * 20, str)
		i ++
	}
}