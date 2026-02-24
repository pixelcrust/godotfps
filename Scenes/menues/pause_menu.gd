extends Node2D

func _physics_process(delta):

	#if Input.is_action_just_pressed("key_pause"):
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		#get_tree().paused = false

func _on_button_continue_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
