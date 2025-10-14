extends "res://attack_hitbox.gd"

@export var ko_velocity_x = 0
@export var ko_velocity_y = 0

func _ready() -> void:
	ko_velocity = Vector2(ko_velocity_x,ko_velocity_y)
