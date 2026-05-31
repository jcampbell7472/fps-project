extends Node

@onready var nm : NetworkManager = NetworkManager
@onready var spawner: MultiplayerSpawner = $MultiplayerSpawner

#preload the player scene
var player_scene = preload("res://scenes/player/player.tscn")

func _ready() -> void:
	nm.players_ready_to_spawn.connect(spawn_players)
	nm.notify_player_ready()

func spawn_players():
	print("Spawning players. ID:", multiplayer.get_unique_id())
	for id in nm.players:
		spawn_player_scene(id)

func spawn_player_scene(player_id : int):
	print(str("Spawning player. ID: ",player_id))
	#instantiate a player scene
	var spawned_player = player_scene.instantiate()
	#change the scene's name to the player's username
	spawned_player.name = nm.players[player_id]
	#set authority for each player
	spawned_player.set_multiplayer_authority(player_id)
	#add player scene to multiplayer spawner
	spawner.add_child(spawned_player,true)
