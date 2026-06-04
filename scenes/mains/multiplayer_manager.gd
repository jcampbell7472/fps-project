extends Node

@onready var nm : NetworkManager = NetworkManager
@onready var spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var spawn_points: Node = $"../SpawnPoints"

var spawned_players = [] #array containing all players

#preload the player scene
var player_scene = preload("res://scenes/player/player.tscn")

func _ready() -> void:
	nm.players_ready_to_spawn.connect(spawn_players) #signal from network manager that notifies whenever every player is ready to spawn
	nm.notify_player_ready() #notify network manager that this player is ready to spawn

#connected to players_ready_to_spawn signal
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
	#set a random spawn point
	spawned_player.position = spawn_points.get_random_spawn_point()
	#add the player to the spawned_players array
	spawned_players.append(spawned_player)
	#addplayer scene as a child of spawner to spawn on every peer
	spawner.add_child(spawned_player,true)

#player death logic

#called when a player shoots another player, takes shot player id as param
func notify_player_shot(player_id : int):
	rpc("player_death",player_id)

#trigger death for given player on every peer
@rpc("any_peer","call_local")
func player_death(player_id):
	#loop through players array until correct player is found
	for player in spawned_players:
		if player.player_id == player_id:
			#trigger death function
			player.get_node("DeathController").death()
			break
