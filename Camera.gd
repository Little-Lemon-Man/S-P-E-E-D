extends Camera2D

signal free
#func _ready():
#	set_physics_process(false)

func _process(delta):
	limit_top = globals.CAM_UP
	limit_bottom = globals.CAM_DOWN
	limit_left = globals.CAM_LEFT
	limit_right = globals.CAM_RIGHT
	if not zoom == globals.CAM_ZOOM:
		zoom.x = move_toward(zoom.x, globals.CAM_ZOOM.x, delta/2)
		zoom.y = move_toward(zoom.y, globals.CAM_ZOOM.y, delta/2)
		limit_smoothed = false
		if zoom == globals.CAM_ZOOM:
			position_smoothing_enabled = false
			limit_smoothed = true
			position_smoothing_enabled = true

func _free():
	enabled = false
