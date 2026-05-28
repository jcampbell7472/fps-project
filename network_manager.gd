extends Node

signal player_list_updated

var usrnm : String
var host_ip : String

#dictionary to contain player info, keyed by unique id
var players = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func create_host(player_name : String):
	usrnm = player_name
	
	#create server
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	
	#add host id and username to player list dict
	players.get_or_add(multiplayer.get_unique_id(),usrnm)

func create_client(player_name : String, target_ip : String):
	usrnm = player_name
	host_ip = target_ip
	
	#create client
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(host_ip,1027)
	multiplayer.multiplayer_peer = peer


func _on_peer_connected(id):
	#send the new peer the current player dict
	rpc_id(id,"send_player_dict", players)

func _on_peer_disconnected(id):
	players.erase(id)
	update_all_player_dict(players)

@rpc ("any_peer","call_local")
func update_all_player_dict(new_players : Dictionary):
	players = new_players
	player_list_updated.emit()

@rpc ("authority","call_remote")
func send_player_dict(new_players : Dictionary):
	#set local dict to dict from host
	players = new_players
	#add new player to dict
	players[multiplayer.get_unique_id()] = usrnm
	#send it back to every peer
	rpc("update_all_player_dict",players)
