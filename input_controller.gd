extends Node

signal pause_changed(is_paused: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pause_changed.emit(false)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			pause_changed.emit(true)
