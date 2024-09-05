extends CharacterBody3D

@onready var interaction_time = .01
var player = 0
@export var title = "Gablo:"
@export var text = "Guat, ba dir?"
@export var cooldown_time = 5

@onready var outline_mesh = $MeshInstance3D/MeshInstance3D

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@export var SOUND_VOICEOVER = preload("res://Sounds/WhatsApp Audio 2024-09-05 at 14.38.16.wav")

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

func get_interaction_time():
	return interaction_time
	
func use():
	player.start_conversation(cooldown_time)
	player.display_conversation.clear()
	player.display_conversation.insert_text_at_caret(title)
	player.display_conversation.insert_text_at_caret("\n \n")
	player.display_conversation.insert_text_at_caret(text)
	
	audio_stream_player_3d.stream = SOUND_VOICEOVER
	audio_stream_player_3d.play(0.0)
