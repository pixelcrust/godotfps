extends Node2D

@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var SOUND_CLICK = preload("res://Sounds/button_on_off_064.wav")

func _physics_process(delta):
	print("im not paused")
	#if Input.is_action_just_pressed("key_pause"):
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		#get_tree().paused = false
	
	if Input.is_action_just_pressed("key_pause"):
			
			if Global.in_conversation == false:
				if Global.paused == true:
					Global.paused = false
					visible = false
				else:
					Global.paused = true
					visible = true
				pause_game()
			
func _on_button_continue_pressed() -> void:
	audio_stream_player_2d.stream = SOUND_CLICK
	audio_stream_player_2d.play(0.6)
	await get_tree().create_timer(.2).timeout
	Global.paused = false
	visible = false
	pause_game()


func pause_game():
	if Global.paused == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false


func _on_button_exit_pressed() -> void:
	audio_stream_player_2d.stream = SOUND_CLICK
	audio_stream_player_2d.play(0.6)
	await get_tree().create_timer(.2).timeout
	get_tree().change_scene_to_file("res://Scenes/menues/menu.tscn")


func _on_button_options_pressed() -> void:
	pass # Replace with function body.
