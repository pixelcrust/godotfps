extends Node3D

@onready var heal_amount = 100
@onready var interactiontime = 3
@onready var player = 0
@onready var outline_mesh = $RigidBody3D/MeshInstance3D/MeshInstance3D
@onready var audio_stream_player_3d = $AudioStreamPlayer3D
const SOUND_USE = preload("res://Sounds/C&S035.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_interaction_time():
	return interactiontime

func use():
	var heal = min(heal_amount,player.hp_start-player.hp)
	audio_stream_player_3d.stream = SOUND_USE
	audio_stream_player_3d.play(0.0)
	player.heal(heal)
	

