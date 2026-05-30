extends Node

signal progress_changed(progress)
signal load_finished

var loading_screen : PackedScene = preload("uid://d23somi53olt") #uid or scene path of loading screen
var loaded_resource : PackedScene
var scene_path : String
var progress: Array = [] #array weirdly needed for loading progress float - see load_status in _process
var use_sub_threads: bool = true #set to true to use sub threads for faster loading

func _ready() -> void:
	#stop processing until scene loading is started
	set_process(false)

#pass the path of the scene to be loaded
func load_scene(_scene_path: String):
	scene_path = _scene_path
	
	#instanitate loading screen
	var new_load_screen = loading_screen.instantiate()
	#add it as a child of scene_loader
	add_child(new_load_screen)
	#connect signals in loading screen
	progress_changed.connect(new_load_screen._on_progress_changed) #signal to pass loading progress
	load_finished.connect(new_load_screen._on_load_finished) #signal emitted when loading is complete to end loading screen
	
	#wait until the initial fade in animation is done, comes from signal in loading_screen
	await new_load_screen.loading_screen_ready
	
	start_load()

func start_load():
	#make request to start loading the scene using sub threads if use_sub_threads is true. sub threads allow for faster loading
	var state = ResourceLoader.load_threaded_request(scene_path, "", use_sub_threads)
	#enable process if request is OK
	if state == OK:
		set_process(true)

#this process repeatedly checks the status of the loading request
func _process(delta: float) -> void:
	#get the current loading status
	var load_status = ResourceLoader.load_threaded_get_status(scene_path, progress) #weirdly pass progress array - returns one element array containing progress ratio (between 0.0 and 1.0)
	#emit signal to pass loading progress to loading screen, optional use
	progress_changed.emit(progress[0])
	#switch that checks if loading has failed or succeeded
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			set_process(false)
			#maybe add a signal emit here to communicate a failed load (show error message to player)
		ResourceLoader.THREAD_LOAD_LOADED:
			#get the loaded resource from the loader
			loaded_resource = ResourceLoader.load_threaded_get(scene_path)
			#change the scene
			get_tree().change_scene_to_packed(loaded_resource)
			#notify loading screen that loading is finished
			load_finished.emit()
