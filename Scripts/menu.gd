extends Node2D

@onready var button_new_game = $button_new_game
@onready var button_continue = $button_continue
@onready var button_options = $button_options
@onready var button_exit = $button_exit
var file = null
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

@onready var SOUND_CLICK = preload("res://Sounds/button_on_off_064.wav")


var audio_player = preload("res://music_player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	var new_audio_player = audio_player.instantiate()
	get_tree().root.get_children()[0].add_child(new_audio_player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.

func _on_button_exit_pressed():
	audio_stream_player_2d.stream = SOUND_CLICK
	audio_stream_player_2d.play(0.6)
	await get_tree().create_timer(.2).timeout
	get_tree().quit()


func _on_button_new_game_pressed():
	audio_stream_player_2d.stream = SOUND_CLICK
	audio_stream_player_2d.play(0.06)
	await get_tree().create_timer(.2).timeout
	get_tree().change_scene_to_file("res://Scenes/menues/loadscreen.tscn")


func _on_button_continue_pressed():
	audio_stream_player_2d.stream = SOUND_CLICK
	audio_stream_player_2d.play(0.06)
	#read from file
	file = FileAccess.open("user://fps-save.txt",FileAccess.READ)
	#file.


func _on_button_options_pressed():
	audio_stream_player_2d.stream = SOUND_CLICK
	audio_stream_player_2d.play(0.06)
	await get_tree().create_timer(.2).timeout
	get_tree().change_scene_to_file("res://Scenes/menues/option.tscn")
