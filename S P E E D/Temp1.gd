extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -500.0
const SPEED_SOFT = 100
const AIR_ADJUST = .05 #how much you can adjust your speed mid-air
const AIR_FRICTION = 50 #inverse, bigger number means less speed loss
const GROUND_FRICTION = 5 #inverse, bigger number means less speed loss
const SWING_SPEED = 300
const GRAPPLE_LENGTH = 1000
const GRAPPLE_ADJUST = 60.6
const GRAPPLE_PULL_SPEED = 10
const GRAPPLE_MINIMUM = 200
var DEFAULT_GRAVITY = 0

var dead = false
var max_health = 100
var current_health = 100
var old_velocity = Vector2(0,0)
var current_gravity = 0
var gravity = 0
var step = 0
var friction = 0
var current_grapple_length = 0
var mouse_angle = (Vector2(1,1)).angle()
var grapple_point = Vector2(0,0)
var applicable_gravity = 1
@export var health = 100

#COUNTERS
var grapple_hover_fix = []

##Checks and cooldowns
var grap_pull = false
var is_knocked_down = false
var is_grappling = false
var attack_cooldown = false
var grapple_cooldown = false


#Just gravity modifiers
var grav_mods = [1]
#var grav_swing = 1
#var grav_swing_hover = 1

signal player_dead
signal AttackTimer
signal GrappleTimer
signal Swing(Angle)
signal Grapple(Point)
signal GrappleCancel
signal free

func _ready():
	DEFAULT_GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
	current_gravity = DEFAULT_GRAVITY
	gravity = current_gravity

func _process(delta):
	
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


	
	
#		if i:
#			gravity = current_gravity
##	INPUTS
	
	if Input.is_action_pressed("Sideways", true):
		if is_knocked_down:
			step = 0
		elif is_on_floor():
			step = 1
		else:
			step = AIR_ADJUST
		var direction = Input.get_axis("Left","Right")
		velocity.x += SPEED * direction * step
	elif is_grappling and not is_on_floor():
		pass
	else:
		if  abs(velocity.x) < 2*SPEED_SOFT:
			friction = (int(abs(velocity.x))^2)/10
		if abs(velocity.x) < SPEED_SOFT/5:
			friction = 1
	

	if (Input.is_action_pressed("Jump")) and is_grappling:
		_grapple_cancel()
		
	
	if Input.is_action_pressed("Attack1") and not attack_cooldown:
		_sword_swing()
		$Timer.start()
		emit_signal("Swing",mouse_angle)
		attack_cooldown = true
		
	if Input.is_action_pressed("Grapple") and not grapple_cooldown:
		_grapple(delta)
	
	
func _physics_process(delta: float) -> void:
	if health <= 0:
		_die()
	print(health)
	if not is_on_floor():
		applicable_gravity = gravity
		for i in grav_mods:
			applicable_gravity *= i
		velocity.y += applicable_gravity * delta
		#print("grav, "+str(applicable_gravity*delta))
	grav_mods = [1]
	velocity.x = move_toward(velocity.x,0,friction)

	globals.PLAYER_POSITION = position
	globals.PLAYER_VELOCITY = velocity
#	print("velo, "+str(velocity))
	old_velocity = velocity
	move_and_slide()
	if dead:
		visible = not visible
	if is_grappling:
		var distance = grapple_point - position
		if grap_pull:
			grap_pull = false
		else:
			if distance.length() > current_grapple_length:
				var adjust = distance - Vector2(current_grapple_length,0).rotated(distance.angle())
				position += adjust
				velocity += Vector2(((int(velocity.length())^2)/current_grapple_length),0).rotated(distance.angle())/delta
#				if (abs(velocity.x) > velocity.y) and (velocity.length() > 20): #(not sign(velocity.y) == -1)
#					grav_mods.append(.5)
	#			velocity += adjust
#				print("adjust, " + str(adjust) + str(velocity))
#				#velocity.y -= gravity
#				var nv = sign(velocity.angle_to(-distance))
#				#print(nv)
#				if nv == -1:
#					print(velocity.rotated((distance.angle()-PI)-velocity.angle()))
##					print('b')
#					velocity = velocity.rotated((distance.angle()-PI/2)-velocity.angle())
#				else:
#					print(velocity.rotated((distance.angle()+PI)-velocity.angle()))
##					print('a')
#					velocity = velocity.rotated((distance.angle()+PI/2)-velocity.angle())
#				print("velo, "+str(velocity))
#				grav_mods.append(2)
				#grav_swing = 2
				#if sign(velocity.x) == sign(distance.x):
				#	gravity = DEFAULT_GRAVITY
				#else:
				#	gravity = DEFAULT_GRAVITY/10
					#(velocity.length()/10)
					#velocity *= (GRAPPLE_ADJUST*delta)
				#print(delta)
				#print(str(velocity.length()) + ", " + str(velocity.angle()) + ", " + str(velocity))
#			else:
#				grav_swing = 1
#			var i = true
#			if globals._within(-velocity.y, velocity.length(), gravity*delta):
#	
#				grav_mods.append(2)
#				print("FALL")
#				i = false
#			if i:
#				print("NO")
	#		if globals._within(sqrt((velocity.length()*velocity.length())/2), velocity.length()/2, gravity*delta) and velocity.y < 0:
	#			grapple_hover_fix.append(1.3)
	#			grav_mods.append_array(grapple_hover_fix)
	#			velocity /= 2.3
	#			print("FALL")
	#		else:
	#			grapple_hover_fix = []
	#			print("NO")
			#print("modifiers, "+ str(grav_mods) + " "+ str(grapple_hover_fix))
	
	##Debug Tools
	
	if Input.is_action_just_pressed("Free Cam"):
		$Camera2D.enabled = false
		emit_signal("free")
	

func _sword_swing():
	pass

func _on_attack_timer_timeout():
	attack_cooldown = false


func _grapple(delta):
	
	if is_grappling:
		var i = Vector2(GRAPPLE_PULL_SPEED,0).rotated((grapple_point - position).angle())
		velocity += (i/delta)/60
		position += i
		if current_grapple_length > GRAPPLE_MINIMUM:
			current_grapple_length -= GRAPPLE_PULL_SPEED
		print("PULL")
		grap_pull = true
		grav_mods.append(0)
	else:
		var grapple = Vector2(GRAPPLE_LENGTH,0).rotated(mouse_angle)
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(position, position+grapple)
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result.has("position"):
			grapple_point = result["position"]
			is_grappling = true
			var i = (grapple_point - position).length()
			if i > GRAPPLE_MINIMUM:
				current_grapple_length = i
			else:
				current_grapple_length = GRAPPLE_MINIMUM
			emit_signal("Grapple", grapple_point)
			grapple_cooldown = true
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
	$AttackHitbox.start()


func _on_grapple_timer_timeout() -> void:
	grapple_cooldown = false

func _grapple_cancel():
	is_grappling = false
	gravity = DEFAULT_GRAVITY
	emit_signal("GrappleCancel")
#	grapple_cooldown = true
#	$Grapple_Timer.start()
	grapple_point = Vector2(0,0)
	grav_mods.append(0)

func _hit(knock_time, damage, knock_velocity, immune_time):
	$Knockout.wait_time = knock_time
	$Knockout.start()
	is_knocked_down = true
	set_process(false)
	health -= damage
	velocity += knock_velocity
#	print(knock_velocity)
	print("PAIN UNDERSTOOD")
	grapple_cooldown = true
	emit_signal("GrappleTimer")
	_grapple_cancel()
	
	
	


func _on_knockout_timeout() -> void:
	is_knocked_down = false
	set_process(true)

func _die():
	emit_signal("player_dead")
	set_process(false)
	collision_layer = 0
	$Hitbox.collision_layer = 0
	$Hitbox.collision_mask = 0
	dead = true
	$Flicker.start()
	

func _on_flicker_timeout() -> void:
	self.queue_free()
