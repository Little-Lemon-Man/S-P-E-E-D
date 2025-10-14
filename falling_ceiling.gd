extends RigidBody2D


func _process(delta: float) -> void:
	$"Falling Ceiling".position.x = lock
	$"Falling Ceiling".rotation = 0
