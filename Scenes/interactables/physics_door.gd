extends RigidBody3D

@onready var door: RigidBody3D = $"."

@onready var outline_mesh = $MeshInstance3D/MeshInstance3D
@onready var audio_stream_player_3d = $"../AudioStreamPlayer3D"
@onready var sound_close = preload("res://Sounds/door close 14.wav")
@onready var sound_open = preload("res://Sounds/door open 7.wav")
@onready var hinge_joint_3d: HingeJoint3D = $"../HingeJoint3D"


@onready var interactiontime = .1
const HP_START = 100
@onready var hp = HP_START

@onready var lower_angle = -110
@export var closed = true
@export var locked = false
@export var blocked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_interaction_time():
	return interactiontime
	
func _on_physical_bone_3d_bodypart_hit(dmg: Variant, time_rooted: Variant) -> void:
	hp -= dmg

func die():
	door.queue_free()
	
func use():
	if closed == true:
		if not locked or blocked:
			hinge_joint_3d.set_param(hinge_joint_3d.motor/enable,1)
			#hinge_joint_3d.set_param(12,lower_angle)
			#hinge_joint_3d.set_param(11,abs(lower_angle))
			audio_stream_player_3d.stream = sound_open
			audio_stream_player_3d.play(0.0)
			closed = false
			print("upperlimit: "+str(hinge_joint_3d.get_param(HingeJoint3D.PARAM_LIMIT_UPPER)))
	else:
		hinge_joint_3d.FLAG_ENABLE_MOTOR
		audio_stream_player_3d.stream = sound_close
		audio_stream_player_3d.play(0.0)
		closed = true
		print("door closed")
