extends Node3D
@onready var audio_stream_player_3d = $AudioStreamPlayer3D
const SOUND_DRONE = preload("res://Sounds/Atmosphere_Drone_001.wav")

const SPEED = 10
var risen = false
var height = 25
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
	audio_stream_player_3d.stream = SOUND_DRONE
	audio_stream_player_3d.play(0.0)
	print("risen: "+str(risen))
	risen = true
