extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0
const SPEED_SOFT = 100
const AIR_ADJUST = .05 #how much you can adjust your speed mid-air
const AIR_FRICTION = 50 #inverse, bigger number means less speed loss
const GROUND_FRICTION = 5 #inverse, bigger number means less speed loss
const SWING_SPEED = 250
const GRAPPLE_LENGTH = 1000
const GRAPPLE_ADJUST = 60.6
var DEFAULT_GRAVITY = 0

var old_velocity = Vector2(0,0)
var current_gravity = 0
var gravity = 0
var step = 0
var friction = 0
var current_grapple_length = 0
var attack_cooldown = false
var grapple_cooldown = false
var is_grappling = false
var mouse_angle = (Vector2(1,1)).angle()
var grapple_point = Vector2(0,0)
@export var health = 100

#COUNTERS
var grapple_hover_fix = []

#Just gravity modifiers
var grav_mods = [1]
#var grav_swing = 1
#var grav_swing_hover = 1


signal AttackTimer
signal GrappleTimer
signal Swing(Angle)
signal Grapple(Point)
signal GrappleCancel

func _ready():
	DEFAULT_GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
	current_gravity = DEFAULT_GRAVITY
	gravity = current_gravity

func _physics_process(delta):
	
	mouse_angle = (get_global_mouse_position() - position).angle()
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY

	if Input.is_action_just_pressed("y"):
		print(get_viewport_rect())
		
	if abs(velocity.x) > SPEED_SOFT:
		if not is_on_floor():
			friction = abs((int(SPEED_SOFT-abs(velocity.x))^2) / AIR_FRICTION)
		else:
			friction = abs((int(SPEED_SOFT-abs(velocity.x))^2) / GROUND_FRICTION)
	
#Gravity

	if not is_on_floor():
		var applicable_gravity = gravity
		for i in grav_mods:
			applicable_gravity *= i
		velocity.y += applicable_gravity * delta
		print(applicable_gravity*delta)
		grav_mods = [1]
#		if i:
#			gravity = current_gravity
	
	if Input.is_action_pressed("Sideways", true):
		if is_on_floor():
			step = 1
		else:
			step = AIR_ADJUST
		var direction = Input.get_axis("Left","Right")
		velocity.x += SPEED * direction * step
	elif is_grappling:
		pass
	else:
		if  abs(velocity.x) < 2*SPEED_SOFT:
			friction = (int(abs(velocity.x))^2)/10
		if abs(velocity.x) < SPEED_SOFT/5:
			friction = 1
	
	velocity.x = move_toward(velocity.x,0,friction)
	
	#Grapple Cancel
	if (Input.is_action_pressed("Jump")) and is_grappling:
		_grapple_cancel()
		
	
	if Input.is_action_pressed("Attack1") and not attack_cooldown:
		_sword_swing()
		emit_signal("AttackTimer")
		emit_signal("Swing",mouse_angle)
		attack_cooldown = true
		
	if Input.is_action_pressed("Grapple") and not grapple_cooldown:
		emit_signal("GrappleTimer")
		_grapple()
		grapple_cooldown = true
	
	globals.PLAYER_POSITION = position
	globals.PLAYER_VELOCITY = velocity
	print(velocity)
	old_velocity = velocity
	move_and_slide()
	if is_grappling:
		var distance = grapple_point - position
		
		if distance.length() > current_grapple_length:
			var adjust = distance - Vector2(current_grapple_length,0).rotated(distance.angle())
			position += adjust
			velocity += adjust
			print("a, " + str(adjust) + str(velocity))
			#velocity.y -= gravity
			var nv = sign(velocity.angle_to(-distance))
			#print(nv)
			if nv == -1:
				#print(velocity.rotated((distance.angle()-PI)-velocity.angle()))
				print('b')
				velocity = velocity.rotated((distance.angle()-PI/2)-velocity.angle())
			else:
				#print(velocity.rotated((distance.angle()+PI)-velocity.angle()))
				print('a')
				velocity = velocity.rotated((distance.angle()+PI/2)-velocity.angle())
			print(velocity)
			grav_mods.append(2)
			#grav_swing = 2
			#if sign(velocity.x) == sign(distance.x):
			#	gravity = DEFAULT_GRAVITY
			#else:
			#	gravity = DEFAULT_GRAVITY/10
				#(velocity.length()/10)
				#velocity *= (GRAPPLE_ADJUST*delta)
			#print(delta)
			#print(str(velocity.length()) + ", " + str(velocity.angle()) + ", " + str(velocity))
#		else:
#			grav_swing = 1
#		var i = true
#		if globals._within(-velocity.y, velocity.length(), gravity*delta):
#
#			grav_mods.append(2)
#			print("FALL")
#			i = false
#		if i:
#			print("NO")
		var i = true
		if globals._within(sqrt((velocity.length()*velocity.length())/2), velocity.length()/2, gravity*delta):
			grapple_hover_fix.append(1.5)
			grav_mods.append_array(grapple_hover_fix)
			velocity /= 1.5
			print("FALL")
			i = false
		if i:
			grapple_hover_fix = []
			print("NO")
				

func _sword_swing():
	pass

func _on_attack_timer_timeout():
	attack_cooldown = false


func _grapple():
	var grapple = Vector2(GRAPPLE_LENGTH,0).rotated(mouse_angle)
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, position+grapple)
	var result = space_state.intersect_ray(query)
	print(result)
	if result.has("position"):
		grapple_point = result["position"]
		is_grappling = true
		current_grapple_length = (grapple_point - position).length()
		emit_signal("Grapple", grapple_point)
		emit_signal("GrappleTimer")
	#print(result["position"])
	#emit_signal("Grapple", result["position"], (Vector2(result["position"])-global_position).length())



func _on_attack_hitbox_timeout() -> void:
	$SwordHitbox.hide()


func _on_node_2d_swing_has_swung() -> void:
	$SwordHitbox.rotation = mouse_angle
	var swing = Vector2(SWING_SPEED,0).rotated(mouse_angle)
	velocity += swing
	$SwordHitbox.show()


func _on_grapple_timer_timeout() -> void:
	grapple_cooldown = false

func _grapple_cancel():
	is_grappling = false
	gravity = DEFAULT_GRAVITY
	emit_signal("GrappleCancel")
	
	
