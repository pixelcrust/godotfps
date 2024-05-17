extends Node3D
@onready var emitter = $emitter
@onready var audio_stream_player_3d = $AudioStreamPlayer3D

@onready var sound_splash = preload("res://Sounds/object dropped in water 6.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_stream_player_3d.stream = sound_splash
	audio_stream_player_3d.play(0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
