extends StaticBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	collision_layer = 128
	collision_mask = 128
	print(body)

func _on_dragon_dead():
	pass
