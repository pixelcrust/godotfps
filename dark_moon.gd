extends Node3D

const SPEED = 10
var rise = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rise == true:
		position += transform.basis * Vector3(0,0,SPEED)*delta

func _rise():
	rise = true
