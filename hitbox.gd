extends Area2D

@export var body: Node


func _ready():
	$".".area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
	body.health -= area.damage
