// Update particles
for (var i = 0; i < ds_list_size(parts); i ++) {
	var prt = parts[|i]
	
	prt.x += prt.speed_x
	prt.y += prt.speed_y
	prt.rot += prt.speed_rot
	prt.alpha += prt.speed_alpha
}

// Cloud alpha
if (cloud_appear) {
	cloud.speed_alpha = 0.05 // cloud becomes stronger
	
	if (cloud.alpha >= 1.2)
		cloud_appear = false // switch
} else {
	cloud.speed_alpha = -0.02 // cloud becomes weaker
	
	if (cloud.alpha <= 0)
		instance_destroy() // effect is done, destroy self
}