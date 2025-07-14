extends Area2D
	




func _on_body_entered(body: Node2D) -> void:
	print("mmk")
	collision_layer = 0
	collision_mask = 0
	hide()
	position = Vector2(0,0)
