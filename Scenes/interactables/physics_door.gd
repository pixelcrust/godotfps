extends RigidBody3D

@onready var door: RigidBody3D = $"."

@onready var outline_mesh = $MeshInstance3D/MeshInstance3D
@onready var audio_stream_player_3d = $"../AudioStreamPlayer3D"
@onready var sound_close = preload("res://Sounds/door close 14.wav")
@onready var sound_open = preload("res://Sounds/door open 7.wav")


@onready var interactiontime = .1
const HP_START = 100
@onready var hp = HP_START

@onready var open = false
@export var closed = false
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
	if open == false:
		audio_stream_player_3d.stream = sound_open
		audio_stream_player_3d.play(0.0)
		open = true
