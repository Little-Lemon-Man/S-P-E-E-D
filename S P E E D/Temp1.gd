extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0
const SPEED_SOFT = 100
const AIR_ADJUST = 0.05 #how much you can adjust your speed mid-air
const AIR_FRICTION = 50 #inverse, bigger number means less speed loss
const GROUND_FRICTION = 5 #inverse, bigger number means less speed loss
const SWING_SPEED = 250
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var step = 1
var friction = 1
var attack_cooldown = false

signal AttackTimer

func _physics_process(delta):

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY

	if abs(velocity.x) > SPEED_SOFT:
		if not is_on_floor():
			friction = abs((int(SPEED_SOFT-abs(velocity.x))^2) / AIR_FRICTION)
		else:
			friction = abs((int(SPEED_SOFT-abs(velocity.x))^2) / GROUND_FRICTION)
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_pressed("Sideways", true):
		if is_on_floor():
			step = 1
		else:
			step = AIR_ADJUST
		var direction = Input.get_axis("Left","Right")
		velocity.x += SPEED * direction * step
	else:
		if  abs(velocity.x) < 2*SPEED_SOFT:
			friction = (int(abs(velocity.x))^2)/10
			print(velocity.x)
		if abs(velocity.x) < SPEED_SOFT/5:
			friction = 1
	
	velocity.x = move_toward(velocity.x,0,friction)
	
	if Input.is_action_pressed("Attack1") and not attack_cooldown:
		_sword_swing()
		emit_signal("AttackTimer")
		attack_cooldown = true
	globals.PLAYER_POSITION = position
	globals.PLAYER_VELOCITY = velocity
	move_and_slide()

func _sword_swing():
	var toward_mouse = get_global_mouse_position() - position
	var swing = Vector2(SWING_SPEED,0).rotated(toward_mouse.angle())
	velocity += swing

func _on_attack_timer_timeout():
	attack_cooldown = false
