extends CharacterBody3D

@onready var player_id : int

func _ready() -> void:
	player_id = get_multiplayer_authority()
	
	#if owned by the local player
	if  is_multiplayer_authority():
		set_collision_layer_value(2,true) #set friendly layer to true
		set_collision_layer_value(3,false) #set enemy layer to false
	else:
		set_collision_layer_value(2,false) #set friendly layer to false
		set_collision_layer_value(3,true) #set enemy layer to true
