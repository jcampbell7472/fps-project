extends Node


@onready var player: CharacterBody3D = $".."
@onready var player_ray_cast: RayCast3D = $"../PlayerCamera/PlayerRayCast"
@onready var multiplayer_manager = get_node("/root/Main/MultiplayerManager")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

#called when the player shoots
func shoot():
	#check if the raycast is colliding with anything and if the local instance owns it
	if player_ray_cast.is_colliding() and is_multiplayer_authority():
		print(str("Player shot: ", player_ray_cast.get_collider().name)," ID: ",player_ray_cast.get_collider().player_id)
		#get the player that was shot (CharacterBody3D)
		var shot_player = player_ray_cast.get_collider()
		#check if the player is alive
		var death_controller = shot_player.get_node("DeathController")
		if death_controller.is_dead == true:
			print("Player is already dead.")
			return
		#notify multiplayer manager that a player was shot, pass the shot player's id
		multiplayer_manager.notify_player_shot(shot_player.player_id)
		#notify multiplayer manager to update scores, pass the shot player's id and score addition
		multiplayer_manager.notify_update_scores(player.player_id,1)

#code for custom raycast (didnt work, may use in future)
#func shoot2():
	#var space = player.get_world_3d().direct_space_state
	#var start_pos = player_camera.position
	#var target_pos = start_pos - (player_camera.global_basis.z * 100)
	#
	#
	#var query = PhysicsRayQueryParameters3D.create(start_pos, target_pos)
	#query.collision_mask = 0b100 #only collide with objects on the enemy_player layer
	#print(str("Shooting with mask: ",query.collision_mask))
	#var collision = space.intersect_ray(query)
	#
	#if collision:
		#test_label.text = collision.collider.name
		#if collision:
			#print("Shoot collided: ")
			#print(collision.collider.name)
			#print(collision.collider.collision_layer)
	#else:
		#test_label.text = "no collision"
