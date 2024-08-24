extends Node2D
@onready var texture_progress_bar: ProgressBar = $TextureProgressBar

var whats_next_scene = 1
var next_scene = null
var next_scene_object = null
var progress = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match whats_next_scene:
		1: 
			next_scene = "res://world.tscn"
		_:
			pass
			
	ResourceLoader.load_threaded_request(next_scene) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	
	var loaded = ResourceLoader.load_threaded_get_status(next_scene,progress)
	texture_progress_bar.value = floor(progress[0]*100)
	if  loaded == 3:
		print("loaded!")
		next_scene_object = ResourceLoader.load_threaded_get(next_scene)
		get_tree().change_scene_to_packed(next_scene_object)
