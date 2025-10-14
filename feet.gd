extends RigidBody2D

func _process(_delta: float) -> void:
	rotation
	$"../Bar".position.x = 0
	position.x = 0
	$"../Bar".rotate(rotation-$"../Bar".rotation)
	
