extends StaticBody2D

func _on_falling_ceiling_dissapear() -> void:
	collision_layer = 0
	collision_mask = 0
	hide()
