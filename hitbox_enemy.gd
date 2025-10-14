extends Area2D
var immune = false
@export var body: Node

func _ready():
#	$".".area_entered.connect(_on_area_entered)
	collision_layer = 0

#	print("A O K")

func _continue(i):
	
	immune = true

func _on_iframes_timeout() -> void:
	immune = false
	#print('hit immune no longer')


func _on_i_frames_timeout() -> void:
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	body._hit(area.ko_time, area.damage, area.ko_velocity)
	print("PAIN FELT")
