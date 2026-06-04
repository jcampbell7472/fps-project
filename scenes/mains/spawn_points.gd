extends Node

var rng = RandomNumberGenerator.new()


#returns the position of a random child Marked3D of SpawnPoints
func get_random_spawn_point() -> Vector3:
	var spawn_points_count = get_child_count()
	var rng_number = rng.randi_range(0,spawn_points_count - 1)
	
	var spawn_position = get_child(rng_number).position
	return spawn_position
