extends Node3D

const sound_leaves_rustle = preload("res://Sounds/leaves rustle 4.wav")
const sound_meow_1 = preload("res://Sounds/meow 1.wav")
const sound_meow_2 = preload("res://Sounds/meow 2.wav")
const sound_meow_3 = preload("res://Sounds/meow 3.wav")

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	pass # Replace with function body.
