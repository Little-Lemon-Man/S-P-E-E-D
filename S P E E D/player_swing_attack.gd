extends "res://attack_hitbox.gd"

@export var knockback = 50
@export var dam_mult = 0.0


func _on_node_2d_swing_has_swung() -> void:
	collision_layer = 16
	collision_mask = 16
	ko_velocity = Vector2(knockback,0).rotated(rotation)
####trial 2 bitch
	var i = $"..".velocity
	var i2 = i.rotated(-rotation).x
	var cur = 100
	if i2 > 0:
		cur = i.length()
	if cur < 100:
		cur = 100
	damage = dam_mult * cur
#	print("damage, " + str(damage))
#	print("i, " + str(i) + ". i2, " +str(i2))


func _on_attack_hitbox_timeout() -> void:
	collision_layer = 0
	collision_mask = 0
	
