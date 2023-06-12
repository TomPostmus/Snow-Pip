function init_pointer_lock() {
	var havePointerLock = 'pointerLockElement' in document ||
    	'mozPointerLockElement' in document ||
    	'webkitPointerLockElement' in document;

	element.requestPointerLock = element.requestPointerLock ||
			     element.mozRequestPointerLock ||
			     element.webkitRequestPointerLock;

	// Ask the browser to lock the pointer
	element.requestPointerLock();

	// Ask the browser to release the pointer
	document.exitPointerLock = document.exitPointerLock ||
			   document.mozExitPointerLock ||
			   document.webkitExitPointerLock;
	document.exitPointerLock();

	// Hook pointer lock state change events
	document.addEventListener('pointerlockchange', changeCallback, false);
	document.addEventListener('mozpointerlockchange', changeCallback, false);
	document.addEventListener('webkitpointerlockchange', changeCallback, false);

	// Hook mouse move events
	document.addEventListener("mousemove", this.moveCallback, false);
}


function mouse_get_displacement_x() {
	return 
}

function mouse_move_center() {

}