event_inherited()

local = true

randomize()
name = "Johannes" + string(irandom(100))		// random name

offline_mode = !instance_exists(obj_client)		// check offline mode

// Offline mode (temporary)
if (offline_mode) {
	pip = instance_create_layer(				// create new pip at current location
			x, y, "Instances", obj_pip
		)
		
		pip.player = self						// pass self and input insts
		pip.input = input
		
		hp = 100								// set hp to full
}