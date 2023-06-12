// Follow target
var corner_x = target.x - camera_get_view_width(view_camera[0]) / 2 // target location (at top-left corner)
var corner_y = target.y - camera_get_view_height(view_camera[0]) / 2
var camera_x = camera_get_view_x(view_camera[0])
var camera_y = camera_get_view_y(view_camera[0])

// Smooth following (P-controller)
var p = 0.1
var next_x = camera_x + (corner_x - camera_x) * p
var next_y = camera_y + (corner_y - camera_y) * p
camera_set_view_pos(view_camera[0], next_x, next_y)