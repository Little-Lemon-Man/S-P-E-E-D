extends RigidBody2D

const SPEED = 50.0
const JUMP_VELOCITY = -400.0
const SPEED_SOFT = 100
const AIR_ADJUST = 0.05 #how much you can adjust your speed mid-air
const AIR_FRICTION = 50 #inverse, bigger number means less speed loss
const GROUND_FRICTION = 5 #inverse, bigger number means less speed loss
const SWING_SPEED = 250
const GRAPPLE_LENGTH = 100
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var step = 1
var friction = 1
var attack_cooldown = false
var mouse_angle = (Vector2(1,1)).angle()
var is_on_floor = true

signal AttackTimer
signal Swing(Angle)
signal Grapple(Point,Length)

func _physics_process(delta):
	if is_on_floor:
		rotation = rotate_toward(rotation, 0, delta*20)
		angular_velocity = move_toward(angular_velocity, 0, delta*10)
		print(angular_velocity)
	mouse_angle = (get_global_mouse_position() - position).angle()
	if Input.is_action_just_pressed("Jump") and is_on_floor:
		linear_velocity.y += JUMP_VELOCITY

	if abs(linear_velocity.x) > SPEED_SOFT:
		if not is_on_floor:
			friction = abs((int(SPEED_SOFT-abs(linear_velocity.x))^2) / AIR_FRICTION)
		else:
			friction = abs((int(SPEED_SOFT-abs(linear_velocity.x))^2) / GROUND_FRICTION)
	
	if Input.is_action_pressed("Sideways", true):
		if is_on_floor:
			step = 1
		else:
			step = AIR_ADJUST
		var direction = Input.get_axis("Left","Right")
		linear_velocity.x += SPEED * direction * step
	else:
		if  abs(linear_velocity.x) < 2*SPEED_SOFT:
			friction = (int(abs(linear_velocity.x))^2)/10
		if abs(linear_velocity.x) < SPEED_SOFT/5:
			friction = 1
	
	linear_velocity.x = move_toward(linear_velocity.x,0,friction)
	
	if Input.is_action_pressed("Attack1") and not attack_cooldown:
		_sword_swing()
		emit_signal("AttackTimer")
		emit_signal("Swing",mouse_angle)
		attack_cooldown = true
	if Input.is_action_pressed("Grapple"):
		_grapple()
	globals.PLAYER_POSITION = position
	globals.PLAYER_VELOCITY = linear_velocity
	#move_and_slide()

func _sword_swing():
	$Area2D.rotation = mouse_angle
	var swing = Vector2(SWING_SPEED,0).rotated(mouse_angle)
	linear_velocity += swing
	$Area2D.show()

func _on_attack_timer_timeout():
	attack_cooldown = false


func _grapple():
	var grapple = Vector2(GRAPPLE_LENGTH,0).rotated(mouse_angle)
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, position+grapple)
	var result = space_state.intersect_ray(query)
	print(result)
	#print(result["position"])
	#emit_signal("Grapple", result["position"], (Vector2(result["position"])-global_position).length())




func _on_area_2d_2_body_entered(body: Node2D) -> void:
	is_on_floor = true


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	is_on_floor = false
