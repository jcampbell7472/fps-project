extends Control

var nm = NetworkManager
@onready var mm = get_node("/root/Main/MultiplayerManager")

@onready var death_controller: Node = $"../DeathController"
@onready var input_controller: Node = $"../InputController"

@onready var player_list: TextEdit = $PlayerList
@onready var death_ui: Control = $DeathUI
@onready var pause_ui: Control = $PauseUI
@onready var crosshair: TextureRect = $Crosshair

@onready var sens_edit: SpinBox = $PauseUI/SensEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_multiplayer_authority():
		return
	
	death_controller.death_state_changed.connect(toggle_death_ui)
	input_controller.pause_changed.connect(toggle_pause_ui)
	input_controller.pause_changed.connect(toggle_crosshair)
	mm.score_updated.connect(update_player_list)
	
	#make the player list visible
	player_list.visible = true
	death_ui.visible = false
	
	#set the initial player list - Note: this should probably just be a call to update_player_list, but it gets called before all players spawn, so list is incorrect
	for id in nm.players:
		if id == nm.id:
			player_list.text += nm.players[id] + " (you)" + "\n"
		else:
			player_list.text += nm.players[id] + "\n"
	
	sens_edit.value = 5

func update_player_list():
	#update player list with score appended
	player_list.clear()
	for player in mm.spawned_players:
		if player.player_id == get_multiplayer_authority():
			player_list.text += str(player.name ," (you)"," : ", mm.player_scores[player.player_id],"\n")
		else:
			player_list.text += str(player.name ," : ", mm.player_scores[player.player_id],"\n")

func toggle_death_ui(is_dead : bool):
	if is_dead:
		death_ui.visible = true
	else:
		death_ui.visible = false

func toggle_pause_ui(is_paused : bool):
	if is_paused:
		pause_ui.visible = true
	else:
		pause_ui.visible = false

func toggle_crosshair(is_paused : bool):
	if is_paused:
		crosshair.visible = false
	else:
		crosshair.visible = true
