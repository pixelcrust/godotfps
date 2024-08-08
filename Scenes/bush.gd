extends Node3D

@onready var audio_stream_player_3d = $AudioStreamPlayer3D
const SOUND_ENTER_BUSH = preload("res://Sounds/Green,Onions,Frozen,Crunch01.wav")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_3d_body_entered(body):
		audio_stream_player_3d.stream = SOUND_ENTER_BUSH
		audio_stream_player_3d.play(0.0)
