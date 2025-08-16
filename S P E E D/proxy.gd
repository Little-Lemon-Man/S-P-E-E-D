extends Node2D

signal hit
signal start

func _on_hit() -> void:
	emit_signal("hit")
func _on_start():
	emit_signal("start")
