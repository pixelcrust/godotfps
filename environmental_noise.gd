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
	timer.wait_time = cooldown
	timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _on_timer_timeout():
	print("timeout")
	play_random_sound()
	
func play_random_sound():
	randomize()
	var case = randi_range(0,3)
	match case:
		0:
			audio_stream_player_3d.stream = sound_meow_1
			audio_stream_player_3d.play(0.0)
		1:
			audio_stream_player_3d.stream = sound_meow_2
			audio_stream_player_3d.play(0.0)
		2:
			audio_stream_player_3d.stream = sound_meow_3
			audio_stream_player_3d.play(0.0)
		3:
			audio_stream_player_3d.stream = sound_leaves_rustle
			audio_stream_player_3d.play(0.0)
		_:
			pass
	
	timer.wait_time = cooldown
	timer.start()
	change_position()
	
func change_position():
	var random_x = randi_range(-100,100)
	var random_y = randi_range(-100,100)
	var random_z = randi_range(-100,100)
	position = Vector3(random_x,random_y,random_z)
