extends Area2D

@export var body: Node

func _ready():
	$".".area_entered.connect(_on_area_entered)
	collision_layer = 0
#	print("A O K")

func _on_area_entered(area: Area2D):
	body._hit(area.ko_time, area.damage, area.ko_velocity)
#	print("PAIN FELT")
	
	
