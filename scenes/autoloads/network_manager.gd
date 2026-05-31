extends Node

signal player_list_updated #signal emitted when the player dictionary is changed
signal players_ready_to_spawn #signal emitted when every player has loaded their game scene and is ready to spawn

const PORT = 1027 #default port used to connect to a server

var usrnm : String #the username of this peer
var id : int #the id of this peer

var ready_players : int = 0

#dictionary to contain player info, keyed by unique id
var players = {}

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	

#called when a host creates a lobby
func create_host(player_name : String):
	usrnm = player_name
	
	#create server
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	
	#add host id and username to player list dict
	id = multiplayer.get_unique_id()
	players.get_or_add(multiplayer.get_unique_id(),usrnm)

#called when a player joins a host in the lobby
func create_client(player_name : String, target_ip : String):
	usrnm = player_name
	
	#create client
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(target_ip,PORT)
	multiplayer.multiplayer_peer = peer
	
	id = multiplayer.get_unique_id()

func _on_peer_connected(player_id):
	#send the new peer the current player dict
	if multiplayer.is_server():
		rpc_id(player_id,"send_player_dict", players)

func _on_peer_disconnected(player_id):
	players.erase(player_id)
	update_all_player_dict(players)

#updates every peers players dict
@rpc ("any_peer","call_local")
func update_all_player_dict(new_players : Dictionary):
	players = new_players
	player_list_updated.emit()

#called by server on new peer when they connect
@rpc ("any_peer","call_remote")
func send_player_dict(new_players : Dictionary):
	#set local dict to dict from host
	players = new_players
	#add new player to dict
	players[multiplayer.get_unique_id()] = usrnm
	#send it back to every peer
	rpc("update_all_player_dict",players)

#called in lobby by host
func start_game():
	rpc("start_all_game")

#tells every peer to change their scene to main
@rpc ("authority","call_local")
func start_all_game():
	#get_tree().change_scene_to_file("res://scenes/mains/main.tscn")
	SceneLoader.load_scene("res://scenes/mains/main.tscn")
	#print(str("Player changing to main scene. ID: ",nm.multiplayer.get_unique_id()))

#ready player logic

#called in multiplayer_manager when their main scene is loaded
func notify_player_ready():
	rpc("player_ready")

#tells server that a peer is ready
@rpc("any_peer","call_local")
func player_ready():
	if multiplayer.is_server():
		ready_players += 1
		if ready_players == len(players):
			rpc("all_players_ready")

#tell every peer that the players are ready to spawn
@rpc("authority","call_local")
func all_players_ready():
	players_ready_to_spawn.emit() #signal used in main/multiplayer_manager to spawn all players
