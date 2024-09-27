extends RigidBody3D

@onready var door: RigidBody3D = $"."

@onready var outline_mesh = $MeshInstance3D/MeshInstance3D
@onready var audio_stream_player_3d = $"../AudioStreamPlayer3D"
@onready var sound_close = preload("res://Sounds/door close 14.wav")
@onready var sound_open = preload("res://Sounds/door open 7.wav")
@onready var hinge_joint_3d: HingeJoint3D = $"../HingeJoint3D"
@onready var lock: Node3D = $lock


@onready var interactiontime = .1
const HP_START = 100
@onready var hp = HP_START

var just_used = false
@onready var lower_angle = -110

@export var closed = true
@export var locked = false
@export var blocked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lock_rotation = true
	if locked == false:
		lock.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("rotation.y = "+str(deg_to_rad(rotation.y)))
	if rotation.y <= deg_to_rad(2) && rotation.y >= deg_to_rad(-2) && just_used == false:
			if rotation.y != 0:
				audio_stream_player_3d.stream = sound_close
				audio_stream_player_3d.play(0.0)
			sleeping = true
			rotation.y = 0
			closed = true


	if rotation.y >= deg_to_rad(2) or rotation.y <= deg_to_rad(-2):
		just_used = false

func get_interaction_time():
	return interactiontime
	
func _on_physical_bone_3d_bodypart_hit(dmg: Variant, time_rooted: Variant) -> void:
	hp -= dmg

func die():
	door.queue_free()
	
func use():
	if closed == true:
		if not locked or blocked:
			lock_rotation = false
			#hinge_joint_3d.set_param(12,lower_angle)
			#hinge_joint_3d.set_param(11,abs(lower_angle))
			audio_stream_player_3d.stream = sound_open
			audio_stream_player_3d.play(0.0)
			closed = false
			just_used = true
	"""else:
		if rotation.y <= deg_to_rad(5) && rotation.y >= deg_to_rad(-5):
			rotation.y = deg_to_rad(0)
			sleeping = true
			lock_rotation = true #only when closed
			audio_stream_player_3d.stream = sound_close
			audio_stream_player_3d.play(0.0)
			closed = true
			print("door closed")"""


func _on_lock_unlock_door() -> void:
	locked = false
