extends Camera2D
var cam_move_speed = 100
var cam_zoom_speed = 1.05
func _ready():
	set_physics_process(false)

func _process(delta: float) -> void:
	position = globals.PLAYER_POSITION

func _on_player_free() -> void:
	enabled = true
	set_process(false)
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Cam Up", true):
		position.y -= cam_move_speed
	if Input.is_action_pressed("Cam Down", true):
		position.y += cam_move_speed
	if Input.is_action_pressed("Cam Left", true):
		position.x -= cam_move_speed
	if Input.is_action_pressed("Cam Right", true):
		position.x += cam_move_speed
	if Input.is_action_pressed("Cam Zoom In", true):
		zoom *= cam_zoom_speed
	if Input.is_action_pressed("Cam Zoom Out", true):
		zoom /= cam_zoom_speed
