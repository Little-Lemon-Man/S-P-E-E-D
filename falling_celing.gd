extends RigidBody2D

signal wait
signal dissapear
var lock = 7632.0
func _ready():
	pass

func _on_timer_timeout():
	collision_layer = 2049
	collision_mask = 2049
	print(collision_layer)
	print(collision_mask)
	emit_signal("dissapear")

func _on_falling_ceiling_trigger_body_entered(body: Node2D) -> void:
	show()
	emit_signal("wait")
	collision_layer = 0
	collision_mask = 0
	linear_velocity.y = 1000
	print(collision_layer)
	print(collision_mask)

func _process(delta: float) -> void:
	position.x = lock
	rotation = 0


func _on_static_body_2d_2_hide() -> void:
	collision_layer = 0
	collision_mask = 0
	hide()
	print('2')
