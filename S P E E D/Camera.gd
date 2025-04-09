extends Camera2D
var Player_Old = Vector2(0,0)

func _process(delta):
	global_position = Player_Old
	Player_Old = globals.PLAYER_POSITION
	
