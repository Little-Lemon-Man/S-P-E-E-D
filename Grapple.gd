extends Line2D


func _ready() -> void:
	set_process(false)
	$"../Player".Grapple.connect(_on_character_body_2d_grapple)
	$"../Player".GrappleCancel.connect(_on_character_body_2d_grapple_cancel)
func _process(_delta) -> void:
	set_point_position(1,globals.PLAYER_POSITION)
	$Hook.rotation = (points[0] - points[1]).angle() + PI/2

func _on_character_body_2d_grapple(Point) -> void:
	set_process(true)
	set_point_position(0,Point)
	$Hook.position = Point
	show()

func _on_character_body_2d_grapple_cancel():
	set_process(false)
	hide()
