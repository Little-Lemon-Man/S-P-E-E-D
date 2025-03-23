extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0
const SPEED_SOFT = 300

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var step = 1

func _physics_process(delta):

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY

	if Input.is_action_pressed("Sideways", true):
		if is_on_floor():
			step = 1
		else:
			step = 0.2
		var direction = Input.get_axis("Left","Right")
		velocity.x += SPEED * direction * step
	elif abs(velocity.x) < 100:
		velocity.x = move_toward(velocity.x,0,5)
		
	var friction = 1
	if not is_on_floor():
		velocity.y += gravity * delta
		friction = abs(velocity.x) * (SPEED_SOFT^2) /500000
	else:
		friction = abs(velocity.x) * (SPEED_SOFT^2) /5000

	velocity.x = move_toward(velocity.x,0,friction)
	
	if Input.is_action_pressed("Attack1"):
		_sword_swing()
	
	

	move_and_slide()

func _sword_swing():
	var toward_mouse = get_global_mouse_position() - position
	var swing_speed = Vector2(50,0).rotated(toward_mouse.angle())
	velocity += swing_speed
