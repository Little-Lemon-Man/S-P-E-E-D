extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0
const SPEED_SOFT = 100
const AIR_ADJUST = 0.1 #how much you can adjust your speed mid-air
const AIR_FRICTION = 50 #inverse, bigger number means less speed loss
const GROUND_FRICTION = 10 #inverse, bigger number means less speed loss
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var step = 1

func _physics_process(delta):

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY

	var friction = 1
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_pressed("Sideways", true):
		if is_on_floor():
			step = 1
		else:
			step = AIR_ADJUST
			
		var direction = Input.get_axis("Left","Right")
		velocity.x += SPEED * direction * step
	
	if is_on_floor():
		friction = friction/GROUND_FRICTION
	else:
		friction = friction/AIR_FRICTION
	if abs(velicity.x) >
	velocity.x /= friction
	
	if Input.is_action_pressed("Attack1"):
		_sword_swing()
	
	

	move_and_slide()

func _sword_swing():
	var toward_mouse = get_global_mouse_position() - position
	var swing_speed = Vector2(50,0).rotated(toward_mouse.angle())
	velocity += swing_speed
