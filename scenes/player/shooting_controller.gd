extends Node

@onready var player: CharacterBody3D = $".."
@onready var player_ray_cast: RayCast3D = $"../PlayerCamera/PlayerRayCast"
@onready var test_label: Label = $"../HUD/TestLabel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot():
	if player_ray_cast.is_colliding():
		print(str("Player shot: ", player_ray_cast.get_collider().name))

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
