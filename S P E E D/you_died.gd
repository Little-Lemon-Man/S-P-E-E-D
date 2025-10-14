extends Polygon2D
var on = false
const fade_time = 5

func _ready() -> void:
	scale.y = get_viewport_rect().size.y / 648
	scale.x = scale.y
	scale *= 1.4


func _process(delta):
	if on and not modulate[3] > 1:
		modulate[3] += delta / fade_time

func _on_player_player_dead() -> void:
	on = true
