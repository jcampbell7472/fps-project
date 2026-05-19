extends Camera3D

const SENSITIVITY = 0.1
const PITCH_MAX = 85
const PITCH_MIN = -85

var yaw = 0
var pitch = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw -= event.screen_relative.x * SENSITIVITY
		pitch -= event.screen_relative.y * SENSITIVITY
		pitch = clamp(pitch, PITCH_MIN, PITCH_MAX)

func _process(delta: float) -> void:
	rotation_degrees = Vector3(pitch,yaw,0)
