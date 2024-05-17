extends Node3D


@onready var audio_stream_player_3d = $AudioStreamPlayer3D

const sound_leaves_rustle = preload("res://Sounds/leaves rustle 4.wav")
const sound_meow_1 = preload("res://Sounds/meow 1.wav")
const sound_meow_2 = preload("res://Sounds/meow 2.wav")
const sound_meow_3 = preload("res://Sounds/meow 3.wav")

@onready var timer = $Timer
@onready var cooldown = 1
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	#timer.wait_time = cooldown
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _on_timer_timeout():
	play_random_sound()
	
func play_random_sound():
	randomize()
	var my_random_number = rng.randf_range(-10.0, 10.0)
	audio_stream_player_3d.stream = sound_meow_1
	audio_stream_player_3d.start(0.0)


func change_position():
	pass
