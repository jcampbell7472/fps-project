extends Camera3D

var rotation_enabled = true

const SENSITIVITY = 0.1
const PITCH_MAX = 85
const PITCH_MIN = -85

var yaw = 0
var pitch = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_multiplayer_authority():
		make_current()
	else:
		visible = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && rotation_enabled:
		yaw -= event.screen_relative.x * SENSITIVITY
		pitch -= event.screen_relative.y * SENSITIVITY
		pitch = clamp(pitch, PITCH_MIN, PITCH_MAX)

func _process(delta: float) -> void:
	rotation_degrees = Vector3(pitch,yaw,0)


func _on_input_controller_pause_changed(is_paused: bool) -> void:
	rotation_enabled = is_paused
