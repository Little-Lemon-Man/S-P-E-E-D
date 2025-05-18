extends Camera2D

func _process(_delta):
	limit_top = globals.CAM_UP
	limit_bottom = globals.CAM_DOWN
	limit_left = globals.CAM_LEFT
	limit_right = globals.CAM_RIGHT
