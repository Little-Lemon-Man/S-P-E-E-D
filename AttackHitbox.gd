extends Area2D

func _process(_delta):
	rotation = $"..".velocity.angle()
