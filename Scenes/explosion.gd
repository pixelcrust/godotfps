extends Node3D

@onready var idle = true
@onready var sparks = $sparks
@onready var flash = $flash
@onready var smoke = $smoke
@onready var radius = 20




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if idle != true:
		sparks.set_emitting(true)
		flash.set_emitting(true)
		smoke.set_emitting(true)
		idle = true



func _signal_explosion():
	print("boom")
	idle = false # Replace with function body.
