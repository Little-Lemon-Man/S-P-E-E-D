extends CharacterBody2D

@export var health = 100
var is_knocked_down = false

var DEFAULT_GRAVITY = 0
var current_gravity = 0
var gravity = 0
const AIR_FRICTION = 50
const GROUND_FRICTION = 1
@export var SPEED_SOFT = 100
@export var fric_coef = 2.0
var friction = 1
var sight_follow_speed = PI/2
var dead = false
signal hit
signal start

func _hit(knock_time, damage, knock_velocity, i_time):
	$Knockout.wait_time = float(knock_time)
	$Knockout.start()
#	is_knocked_down = true
	set_process(false)
	health -= damage
	velocity += knock_velocity
	if health <= 0:
		_die()
	emit_signal("hit")
#	print("PAIN UNDERSTOOD")
	

func _ready():
	DEFAULT_GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
	current_gravity = DEFAULT_GRAVITY
	gravity = current_gravity
	emit_signal("start")
#	print("SET")

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
#	print(velocity)
	move_and_slide()
	if dead:
		visible = not visible


	if not is_on_floor():
		friction = fric_coef / AIR_FRICTION
#		print("a")
	else:
		friction = fric_coef / GROUND_FRICTION
#		print("b")
	velocity.x = move_toward(velocity.x,0,friction)
#	print(friction)

func _die():
	set_process(false)
	collision_layer = 0
	$Area2D.collision_layer = 0
	$Area2D.collision_mask = 0
	dead = true
	$Flicker.start()
	pass
	


func _on_flicker_timeout() -> void:
	self.queue_free()


func _on_knockout_timeout() -> void:
	set_process(true)
