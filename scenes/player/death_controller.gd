extends Node

@onready var spawn_points = get_node("/root/Main/SpawnPoints")
@onready var player: CharacterBody3D = $".."


signal death_state_changed(is_dead : bool)

@export var respawn_wait_time : float = 3 #how long it takes for the player to respawn

var is_dead : bool = false #bool to store if the player is dead or not

func _ready() -> void:
	pass

func death():
	#set player as dead and emit signal
	is_dead = true
	death_state_changed.emit(is_dead)
	
	#wait before respawning
	await get_tree().create_timer(respawn_wait_time).timeout
	
	respawn()

func respawn():
	#set position to random spawn point
	player.global_position = spawn_points.get_random_spawn_point()
	
	#set player to alive and emit signal
	is_dead = false
	death_state_changed.emit(is_dead)
	
