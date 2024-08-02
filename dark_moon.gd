extends Node3D

const SPEED = 10
var risen = false
# Called when the node enters the scene tree for the first time.
func _ready():
	print($".")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if risen == true:
		print("its rising")
		position += transform.basis * Vector3(0,SPEED,0)*delta

func rise():
	print("risen: "+str(risen))
	risen = true
