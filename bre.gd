extends Node2D

func _process(delta: float) -> void:
	global_scale = Vector2(1,1)
	var bitch = $"../../../Mouth Pointer/PathFollow2D".global_position
	rotate(get_angle_to(bitch))
