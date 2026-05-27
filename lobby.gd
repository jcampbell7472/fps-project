extends Node

@onready var disconnect_button: Button = $LobbyUI/DisconnectButton

#Joining and Hosting UI elements
@onready var join_and_host_ui: Control = $LobbyUI/JoinAndHostUI

@onready var player_name_text_box: LineEdit = $LobbyUI/JoinAndHostUI/PlayerNameTextBox
@onready var address_text_box: LineEdit = $LobbyUI/JoinAndHostUI/AddressTextBox
@onready var join_button: Button = $LobbyUI/JoinAndHostUI/JoinButton
@onready var lobby_name_text_box: LineEdit = $LobbyUI/JoinAndHostUI/LobbyNameTextBox
@onready var host_button: Button = $LobbyUI/JoinAndHostUI/HostButton


#Chat UI elements
@onready var chat: Control = $LobbyUI/Chat
@onready var send_button: Button = $LobbyUI/Chat/SendButton
@onready var message_text_box: LineEdit = $LobbyUI/Chat/MessageTextBox
@onready var messages: TextEdit = $LobbyUI/Chat/Messages

#Player List
@onready var lobby_info: Control = $LobbyUI/LobbyInfo
@onready var player_list: TextEdit = $LobbyUI/LobbyInfo/PlayerList

var usrnm : String
var host_ip : String

#dictionary to contain player info, keyed by unique id
var players = {}


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	
	host_ip = "127.0.0.1"


func _on_host_button_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(1027)
	#get_tree().set_multiplayer(SceneMultiplayer.new(),self.get_path())
	multiplayer.multiplayer_peer = peer
	joined()
	
	#add host id and username to player list dict
	players.get_or_add(multiplayer.get_unique_id(),usrnm)
	update_list_text()


func _on_join_button_pressed() -> void:
	if not address_text_box.text == "":
		host_ip = address_text_box.text
	
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(host_ip,1027)
	#get_tree().set_multiplayer(SceneMultiplayer.new(),self.get_path())
	multiplayer.multiplayer_peer = peer
	joined()

func _on_send_button_pressed() -> void:
	rpc("msg_rpc",usrnm,message_text_box.text)
	message_text_box.text = ""

func _on_disconnect_button_pressed() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	get_tree().reload_current_scene()

@rpc ("any_peer","call_local")
func msg_rpc(usrnm,data):
	messages.text += str(usrnm, ": ", data, "\n")
	messages.scroll_vertical = INF

func joined():
	join_and_host_ui.hide()
	chat.show()
	disconnect_button.show()
	usrnm = player_name_text_box.text

#Player list logic

@rpc ("any_peer","call_local")
func update_all_player_dict(new_players : Dictionary):
	players = new_players
	update_list_text()

@rpc ("authority","call_remote")
func send_player_dict(new_players : Dictionary):
	#set local dict to dict from host
	players = new_players
	#add new player to dict
	players[multiplayer.get_unique_id()] = usrnm
	#send it back to every peer
	rpc("update_all_player_dict",players)

func _on_peer_connected(id):
	rpc_id(id,"send_player_dict", players)

func update_list_text():
	player_list.clear()
	for id in players:
		player_list.text += players[id] + "\n"
