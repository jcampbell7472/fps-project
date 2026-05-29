extends CharacterBody3D

func _ready() -> void:
	if not is_multiplayer_authority():
		pass
