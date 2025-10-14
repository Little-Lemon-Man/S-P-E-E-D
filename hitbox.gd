extends Area2D
var immune = false
@export var body: Node

func _ready():
#	$".".area_entered.connect(_on_area_entered)
	collision_layer = 0
#	print("A O K")

#func _on_area_entered(area: Area2D):
#	body._hit(area.ko_time, area.damage, area.ko_velocity)
#	print("PAIN FELT")

func _physics_process(delta: float) -> void:
	var i_time = 0
	var hit = false
	#print('hit check')
	if has_overlapping_areas() and not immune:
		#print('hit found')
		var area = get_overlapping_areas()
		for i in area:
			if i.wall_blocked:
#				print(i.name)
				$WallBlock.target_position = i.global_position - global_position
#				var space_state = get_world_2d().direct_space_state
#				var query = PhysicsRayQueryParameters2D.create($"..".global_position, i.global_position)
#				print(query)
#				query.exclude = [self]
#				var result = space_state.intersect_ray(query)
#				print(result)
				if $WallBlock.is_colliding():
#					if result["collider"].get_parent().get_parent().name == "Walls":
					pass
				else:
					#print('hit walless')
					_continue(i)
					i_time = i.i_time
					hit = true
			else:
				#print('hit not blocked')
				_continue(i)
				i_time = i.i_time
				hit = true
				print('wah')
	if hit:
		$"../I-frames".wait_time = i_time
		$"../I-frames".start()
		#print('hit immune')
func _continue(i):
	body._hit(i.ko_time, i.damage, i.ko_velocity, i.i_time)
	print("PAIN FELT")
	immune = true

func _on_iframes_timeout() -> void:
	immune = false
	#print('hit immune no longer')


func _on_i_frames_timeout() -> void:
	pass # Replace with function body.
