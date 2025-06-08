extends Node2D


func _on_character_body_2d_grapple(Point,Length) -> void:
	$Point.position = Point
	$DampedSpringJoint2D.length = Length
