extends Node3D

@onready var audio_stream_player_3d = $AudioStreamPlayer3D
const sound_beer_bottle = preload("res://Sounds/Glass_Break_BeerBottle_702T_Fienup_002.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	audio_stream_player_3d.stream = sound_beer_bottle
	audio_stream_player_3d.play(0.0)
