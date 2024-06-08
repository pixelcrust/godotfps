extends Node2D

@onready var button_new_game = $button_new_game
@onready var button_continue = $button_continue
@onready var button_options = $button_options
@onready var button_exit = $button_exit
var file = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.

func _on_button_exit_pressed():
	get_tree().quit()


func _on_button_new_game_pressed():
	get_tree().change_scene_to_file("res://world.tscn")


func _on_button_continue_pressed():
	#read from file
	file = FileAccess.open("user://fps-save.txt",FileAccess.READ)
	#file.


func _on_button_options_pressed():
	get_tree().change_scene_to_file("res://option.tscn")
