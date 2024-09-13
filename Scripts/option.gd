extends Node2D

@onready var back = $back
@onready var sensitivity_slider = $HSlider
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var SOUND_CLICK = preload("res://Sounds/button_on_off_064.wav")
@onready var button_fullscreen = $button_fullscreen

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if button_fullscreen.button_pressed == false:
		#minimized
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		#maximized
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
func _on_button_back_pressed():
	audio_stream_player_2d.stream = SOUND_CLICK
	audio_stream_player_2d.play(0.6)
	await get_tree().create_timer(.2).timeout
	get_tree().change_scene_to_file("res://Scenes/menues/menu.tscn")
