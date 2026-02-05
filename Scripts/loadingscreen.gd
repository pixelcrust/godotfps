extends Node2D
@onready var texture_progress_bar: ProgressBar = $TextureProgressBar

var next_scene = null
var next_scene_object = null
var progress = []

func _ready() -> void:
	print(Global.next_level)
	match Global.next_level:
		"Home": 
			next_scene = "res://Scenes/levels/planned/world3_home.tscn"
		"Workplace":
			next_scene = "res://Scenes/levels/planned/world5_workplace.tscn"
		"Bahnhof":
			next_scene = "res://Scenes/levels/planned/world0_bahnhof.tscn"
		"WalkingHome":
			next_scene = "res://Scenes/levels/planned/world2_walking_home.tscn"
		_:
			next_scene = "res://Scenes/levels/planned/world0_bahnhof.tscn"
	ResourceLoader.load_threaded_request(next_scene) # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	var loaded = ResourceLoader.load_threaded_get_status(next_scene,progress)
	texture_progress_bar.value = floor(progress[0]*100)
	if  loaded == 3:
		print("loaded!")
		next_scene_object = ResourceLoader.load_threaded_get(next_scene)
		get_tree().change_scene_to_packed(next_scene_object)
