extends Node3D


@onready var interaction_time = .01
var player = 0
@export var title = "Mom:"
@export var text = "The only buses are the ones in the morning for the new workers"
@export var cooldown_time = 5

@onready var outline_mesh = $desk_phone_with_cable2.outline_mesh

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@export var SOUND_VOICEOVER = preload("res://Sounds/WhatsApp Audio 2024-09-05 at 14.38.16.wav")

func _ready():
	player = get_tree().get_nodes_in_group("player_root")[0]



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
