extends Node

@onready var nm : NetworkManager = NetworkManager
@onready var spawner: MultiplayerSpawner = $MultiplayerSpawner

#preload the player scene
var player_scene = preload("res://scenes/player/player.tscn")

#array to contain every spawned player
var current_players : Array = []

#counter for number of players in game
var players_in_game : int = 0

func _ready() -> void:
	#notify server that player has joined, pass the player's id
	im_in_game.rpc(nm.id)

@rpc("any_peer","call_local","reliable")
func im_in_game (id : int):
	#check that only the server is running the function
	if nm.multiplayer.is_server():
		print(str("Player joined. ID: ",id))
		#increment player count
		players_in_game += 1
		
		#if every player has joined, spawn each player
		if players_in_game == len(nm.players):
			print("Every player joined game. Spawning players.")
			spawn_players.rpc()


@rpc("any_peer","call_local")
func spawn_players():
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
