extends "res://enemy_char.gd"

var player_direction = Vector2(0,0)
var speed = 500
var angle = 0
var attack_cooldown = false
signal Swing
var play_last_seen = 0
var play_seen_recent = false
var step = 1
@export var start_angle = 0

func _process(delta: float) -> void:
#	print("s")
	if $Detection.has_overlapping_bodies():
		play_seen_recent = true
		player_direction = globals.PLAYER_POSITION - position
#		print(str(player_direction)+ ", thre, " + str(player_direction.length()))
		if is_on_floor():
			step = 1
		else:
			step = .1
		if player_direction.length() > 150:
			velocity.x += sign(player_direction.x)*speed*delta*step
			
		if player_direction.length() < 250 and not attack_cooldown:
			angle = player_direction.angle()
			$AttackTimer.start()
			emit_signal("Swing",angle)
			attack_cooldown = true
		if player_direction.angle() - PI/2 > PI:
			$Node2D2/Chestt.flip_h = true
		else:
			$Node2D2/Chestt.flip_h = false
	if play_seen_recent:
		$Detection.rotation = rotate_toward($Detection.rotation, $Point1.get_angle_to(globals.PLAYER_POSITION), sight_follow_speed*delta)
		print("SEE")


func _on_attack_timer_timeout():
	attack_cooldown = false

func _on_attack_hitbox_timeout() -> void:
	$AttaHit.hide()


func _on_swing_has_swung() -> void:
	$AttaHit.rotation = angle
#	var swing = Vector2(SWING_SPEED,0).rotated(mouse_angle)
#	velocity += swing
	$AttaHit.show()
	$AttackHitbox.start()


func _on_detection_body_exited(body: Node2D) -> void:
	$See.start()


func _on_see_timeout() -> void:
	play_seen_recent = false
#	print("soap")


func _on_proxy_hit() -> void:
	play_seen_recent = true
	$See.start()
#	print("spaghett")
	$Collision.start()
	collision_layer = 0


func _on_proxy_start() -> void:
	$Detection.rotation = deg_to_rad(start_angle)


func _on_collision_timeout() -> void:
	collision_layer = 1
