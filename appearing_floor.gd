extends StaticBody2D
signal hide
#func _on_dissapear():
	

#func _on_timer_timeout() -> void:


func _on_hider_timeout() -> void:
	collision_layer = 1
	collision_mask = 1
	show()
	emit_signal("hide")
	print('1')
