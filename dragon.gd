extends CharacterBody2D

@export var health = 1000

signal dragon_dead


var arena_centre = Vector2(12096, -652)
var fly_point = Vector2(7264.0, -984.0)
var fly_point_from_centre = Vector2.ZERO
var grab_point = Vector2(11424, -328)
var grab_point_from_centre = Vector2.ZERO
var fly_speed = 800
var last_edge = 1
var dead = false
@onready var grab_hitbox = $"Node2D/Node2D2/Mouth Path/PathFollow2D/Node2D/GrabFireHitbox"
#for attack, 1 is fly_breath, 2 is fly_low, 3 is under_breath
#for edge, 1 is coming from the left and -1 is coming from the right, 
#
var cycle = [[1, -1], [1, 1], [2, -1], [3, 1], [1, 1], [3, -1]]
#[attack, edge]



var current_attack = "null"



func _process(delta: float) -> void:
	var i = cycle[0][0]
	var edge = cycle[0][1]
	if current_attack == "null":
		$Node2D.scale.x = edge
		if i == 1:
			_fly_breath(edge)
		elif i == 2:
			_fly_low(edge)
		elif i == 3:
			_grab_breath(edge)
		print(current_attack + ' start, ' + str(edge))
		cycle.append(cycle[0])
		cycle.remove_at(0)

func _ready() -> void:
	fly_point_from_centre = arena_centre-fly_point
	grab_point_from_centre = arena_centre-grab_point
	set_process(false)

#	$DragonFire._check()


func _hit(knock_time, damage, knock_velocity):
#	is_knocked_down = true
	health -= damage
#	velocity += knock_velocity
	if health <= 0:
		_die()
	
#	print("PAIN UNDERSTOOD")

func _die():
	emit_signal("dragon_dead")
	set_process(false)
	collision_layer = 0
	$Area2D.collision_layer = 0
	$Area2D.collision_mask = 0
	dead = true
	$Flicker.start()


func _on_fight_start(body: Node2D) -> void:
	set_process(true)
	
func _fly_breath(edge):
	$"Node2D/Attack Hitboxes/FireHitbox".show()
	$"Node2D/Attack Hitboxes/FireHitbox".collision_layer = 534388
	current_attack = "Fly-Breath"
	position = Vector2(arena_centre.x+fly_point_from_centre.x*-edge, fly_point.y)
	velocity.x = fly_speed*edge
	$Node2D/Flying.show()
	$"Node2D/Fly-breath".start()
	$Node2D/Flying.play("breath")
	
func _grab_breath(edge):

	current_attack = "grab_breath"
	$"Grab Timers/Delay".start()
	$"Grab Timers/Next".start()
	$"Grab Timers/Hitbox on".start()
	$Node2D/Grab.show()
	$Node2D/Grab.play("Breath")
	$Node2D/Area2D2.monitoring = true
	$Node2D/Area2D.monitoring = false
	position = Vector2(arena_centre.x+grab_point_from_centre.x*-edge, grab_point.y)


func _physics_process(delta: float) -> void:
	move_and_slide()
	if dead:
		visible = not visible



func _fly_low(edge):
	current_attack = "Fly-Low"
	position = Vector2(arena_centre.x+.75*fly_point_from_centre.x*-edge, fly_point.y+400)
	velocity.x = 1.75*fly_speed*edge
	$Node2D/Flying.play("default")
	$Node2D/Flying.show()
	$"Fly-low".start()

func _on_flybreath_timeout() -> void:
	$"Node2D/Attack Hitboxes/FireHitbox".hide()
	$"Node2D/Attack Hitboxes/FireHitbox".collision_layer = 0
#	$DragonFire.set_process(false)
	velocity = Vector2(0,0)
	current_attack = "null"
	$Node2D/Flying.stop()
	$Node2D/Flying.hide()
	print("Fly-Breath done")
	
func _on_flylow_timeout() -> void:
	velocity = Vector2(0,0)
	current_attack = "null"
	$Node2D/Flying.stop()
	$Node2D/Flying.hide()
	print("Fly-Low done")


func _on_flicker_timeout() -> void:
	self.queue_free()

#delay for the grab hitbox
func _on_delay_timeout() -> void:
	grab_hitbox.show()
	grab_hitbox.collision_layer = 534388
	$"Node2D/Node2D2/Mouth Path/PathFollow2D/Node2D/GPUParticles2D".emitting = true
	$"Grab Timers/Path Step".start()
	

#turning that hitbox off
func _on_hitbox_on_timeout() -> void:
	grab_hitbox.hide()
	grab_hitbox.collision_layer = 0
	$"Grab Timers/Path Step".stop()
	$"Node2D/Node2D2/Mouth Path/PathFollow2D".progress_ratio = 0
	$"Node2D/Node2D2/Mouth Pointer/PathFollow2D".progress_ratio = 0
	$"Node2D/Node2D2/Mouth Path/PathFollow2D/Node2D/GPUParticles2D".emitting = false

#end of the grab attack
func _on_next_timeout() -> void:
	$Node2D/Grab.hide()
	$Node2D/Grab.stop()
	$Node2D/Area2D2.monitoring = false
	$Node2D/Area2D.monitoring = true
	current_attack = "null"
	print("Grab-Breath Done")

#making the grab hitbox wave around
func _on_path_step_timeout() -> void:
	$"Node2D/Node2D2/Mouth Path/PathFollow2D".progress_ratio += 0.02083333333
	$"Node2D/Node2D2/Mouth Pointer/PathFollow2D".progress_ratio += 0.02083333333
	
