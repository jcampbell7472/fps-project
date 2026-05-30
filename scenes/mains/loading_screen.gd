extends CanvasLayer

signal loading_screen_ready

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	await animation_player.animation_finished #wait until the initial fade in animation is done
	loading_screen_ready.emit() #tell the scene_loader that the loading screen is ready

func _on_progress_changed(new_value: float):
	pass #can use this float for a progress bar

#called when scene_loader is finished loading the scene
func _on_load_finished():
	#play the fade out animation
	animation_player.play_backwards("transition")
	#wait until the fade out is finished
	await animation_player.animation_finished
	#delete the loading screen
	queue_free()
