extends Node
var PLAYER_VELOCITY = Vector2(0,0)
var PLAYER_POSITION = Vector2(0,0)
var ZOOM_SCALE = 1
var CAM_UP = 0
var CAM_DOWN = 0
var CAM_LEFT = 0
var CAM_RIGHT = 0
var CAM_ZOOM = Vector2(0,0)

func _ready():
	pass
#	ZOOM_SCALE = ___/648

func _within(Target, Separation, Goal):
	if Target < Goal + Separation and Target > Goal - Separation:
		return true
	else:
		return false
