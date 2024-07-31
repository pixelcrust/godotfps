extends Node3D
@onready var interaction_time = .1
# Called when the node enters the scene tree for the first time.
@onready var outline_mesh = $MeshInstance3D/MeshInstance3D
@onready var player = 0
@export var title = "Gablo:"
@export var text = "Guat, ba dir?"
@export var cooldown_time = 5

@onready var audio_stream_player_3d = $AudioStreamPlayer3D
const SOUND_USE = preload("res://Sounds/paper handled 1.wav")

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func get_interaction_time():
	return interaction_time

func use():
	player.start_conversation(cooldown_time)
	player.display_conversation.clear()
	player.display_conversation.insert_text_at_caret(title)
	player.display_conversation.insert_text_at_caret("\n \n")
	player.display_conversation.insert_text_at_caret(text)
	
	audio_stream_player_3d.stream = SOUND_USE
	audio_stream_player_3d.play(0.0)
	print("used it")
