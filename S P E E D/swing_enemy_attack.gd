extends "res://attack_hitbox.gd"


var knockback = 100



	
func _on_attack_hitbox_timeout() -> void:
	collision_layer = 0
	collision_mask = 0

func _on_swing_has_swung() -> void:
	collision_layer = 524288
	collision_mask = 524288
	ko_velocity = Vector2(knockback,0).rotated(rotation)
#	print("damage, " + str(damage))
