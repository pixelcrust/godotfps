extends Node3D

const SPEED = 5
var risen = false
var height = 50
# Called when the node enters the scene tree for the first time.
func _ready():
	print($".")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if risen == true:
		print("its rising")
		if position.y < height:
			position += transform.basis * Vector3(0,SPEED,0)*delta
		else:
			pass
			#explosion

func rise():
	print("risen: "+str(risen))
	risen = true
