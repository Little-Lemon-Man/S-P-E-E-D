extends Area2D


func _process(_delta: float) -> void:
	if  has_overlapping_bodies():
		$"..".is_on_floor = true
	global_rotation = 0
