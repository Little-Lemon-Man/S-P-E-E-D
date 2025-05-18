extends Area2D

var up = 0 + position.y
var down = (648 * scale.y) + position.y
var left = 0 + position.x
var right = (1152 * scale.x) + position.x

@export var scream = ''
@export var up_adjust = 324
@export var down_adjust = 324
@export var left_adjust = 576
@export var right_adjust = 576
@export var zoom_y = float(1)
@export var zoom_x = float(1)
var zoom = Vector2(0,0)

func _ready():
	up = 0 + position.y - up_adjust
	down = (648 * scale.y) + position.y + down_adjust
	left = 0 + position.x - left_adjust
	right = (1152 * scale.x) + position.x + right_adjust
	zoom = Vector2(zoom_x, zoom_y)
	if scream == '':
		scream = str($".").split(":", true, 1)[0]
func _on_body_entered(_body):
	print(scream)
	globals.CAM_UP = up
	globals.CAM_DOWN = down
	globals.CAM_RIGHT = right
	globals.CAM_LEFT = left
	globals.CAM_ZOOM = zoom
