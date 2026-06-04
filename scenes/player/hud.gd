extends Control

var nm = NetworkManager

@onready var death_controller: Node = $"../DeathController"

@onready var player_list: TextEdit = $PlayerList
@onready var death_ui: Control = $DeathUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_multiplayer_authority():
		return
	
	death_controller.death_state_changed.connect(toggle_death_ui)
	
	#make the player list visible
	player_list.visible = true
	death_ui.visible = false
	
	#add all players in lobby to player list
	player_list.text += "Players:" + "\n"
	for id in nm.players:
		if id == nm.id:
			player_list.text += nm.players[id] + " (you)" + "\n"
		else:
			player_list.text += nm.players[id] + "\n"

func toggle_death_ui(is_dead : bool):
	if is_dead:
		death_ui.visible = true
	else:
		death_ui.visible = false
