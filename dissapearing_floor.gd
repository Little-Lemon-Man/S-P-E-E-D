extends StaticBody2D

func _on_dissapear():
	collision_layer = 0
	collision_mask = 0
	hide()
