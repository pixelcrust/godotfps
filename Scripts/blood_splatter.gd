extends Node3D

@onready var on = false
@onready var already = false
@onready var emitter = $GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on == true && already == false:
		already = true
		emitter.emitting = true
