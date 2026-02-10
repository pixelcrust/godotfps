extends Node2D

var current_track : int = 0
var current_time_stamp : float = 0
var paused : bool = false
var volume : int = 50

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("key_music_next")):
		pass
		
	if(Input.is_action_just_pressed("key_music_pause")):
		if(audio_stream_player.stream_paused == true):
			audio_stream_player.stream_paused = false
		else:
			audio_stream_player.stream_paused = true
