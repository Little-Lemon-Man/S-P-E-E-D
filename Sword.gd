extends Node2D
var edge = -1
var target = 0
var setup = false
signal Swing_Has_Swung

func _process(delta: float):
	#if round(rotation) == round(target):
	#	$".".set_process(false)
	if setup:
		rotation = rotate_toward(rotation,target,-5*delta)
		if rotate_toward(0,rotation,-TAU) <= rotate_toward(0,target+.1,TAU) and rotate_toward(0,rotation,-TAU) >= rotate_toward(0,target-.1,TAU):
			setup = false
			rotate(PI/16*edge)
			print('sque')
			$Sword.scale.x = float(edge)/2
			emit_signal("Swing_Has_Swung")
			
	else:
		rotation = rotate_toward(rotation,target,20*delta)



func _on_body_swing(Angle):
	var i = Vector2(1,0).rotated(Angle).rotated(-rotation)
	if i.y > 0:
		edge = 1
		print('aaa')
	else:
		edge = -1
		print('ooo')
	target = Angle + PI/2*edge
	setup = true
	$".".set_process(true)
