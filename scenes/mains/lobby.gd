extends Node

var nm = NetworkManager

@onready var disconnect_button: Button = $LobbyUI/DisconnectButton
@onready var start_button: Button = $LobbyUI/StartButton


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
@onready var username_label: Label = $LobbyUI/LobbyInfo/UsernameLabel




func _ready() -> void:
	nm.player_list_updated.connect(update_list_text)


func _on_host_button_pressed() -> void:
	#check player has inputted a name
	if not player_name_text_box.text == "":
		#create a host player
		nm.create_host(player_name_text_box.text)
		
		#update player list text
		update_list_text()
		#show start button
		start_button.show()
		joined()

func _on_join_button_pressed() -> void:
	if not player_name_text_box.text == "":
		if not address_text_box.text == "":
			nm.create_client(player_name_text_box.text,address_text_box.text)
		else:
			nm.create_client(player_name_text_box.text,"127.0.0.1")
		update_list_text()
		joined()

func _on_disconnect_button_pressed() -> void:
	nm.multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	get_tree().reload_current_scene()

func _on_send_button_pressed() -> void:
	rpc("msg_rpc",nm.usrnm,message_text_box.text)
	message_text_box.text = ""

@rpc ("any_peer","call_local")
func msg_rpc(usrnm,data):
	messages.text += str(usrnm, ": ", data, "\n")
	messages.scroll_vertical = INF

func joined():
	join_and_host_ui.hide()
	chat.show()
	disconnect_button.show()

#Player list logic

func update_list_text():
	#clear current list
	player_list.clear()
	#add every player to list from dict
	for id in nm.players:
		player_list.text += nm.players[id] + "\n"
	username_label.text = "Your username: " + nm.usrnm

#Start game logic

func _on_start_button_pressed() -> void:
	rpc("start_game")

@rpc ("authority","call_local")
func start_game():
	get_tree().change_scene_to_file("res://scenes/mains/main.tscn")
