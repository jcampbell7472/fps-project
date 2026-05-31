extends Control

var nm = NetworkManager

@onready var player_list: TextEdit = $PlayerList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_multiplayer_authority():
		visible = true
	
	#add all players in lobby to player list
	player_list.text += "Players:" + "\n"
	for id in nm.players:
		if id == nm.id:
			player_list.text += nm.players[id] + " (you)" + "\n"
		else:
			player_list.text += nm.players[id] + "\n"
		
