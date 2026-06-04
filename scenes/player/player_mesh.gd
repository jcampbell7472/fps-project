extends MeshInstance3D

@onready var death_controller: Node = $"../DeathController"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_multiplayer_authority():
		visible = false
	
	#connect to the player's death state
	death_controller.death_state_changed.connect(change_visibility)

#called whenever the player's death state changes
func change_visibility(is_dead):
	#if the player is dead make them invisible, visible if alive
	if is_dead:
		visible = false
	else:
		visible = true
