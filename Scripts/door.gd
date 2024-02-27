extends MeshInstance3D

@onready var animation_player = $"../../AnimationPlayer"
@onready var door = $".."
@onready var outline_mesh = $MeshInstance3D
@onready var audio_stream_player_3d = $"../../AudioStreamPlayer3D"
@onready var sound_close = preload("res://Models/Sounds/door close 14.wav")
@onready var sound_open = preload("res://Models/Sounds/door open 7.wav")

const HP_START = 100
@onready var hp = HP_START
@export var open = false
#0.. closed
#1.. open

@onready var interactiontime_open = .01
@onready var interactiontime_close = .01

# Called when the node enters the scene tree for the first time.
func _ready():
	if open == false:
		animation_player.play("animation_close")
	elif open == true:
		animation_player.play("animation_open")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(hp <= 0):
		die()


func _on_physical_bone_3d_bodypart_hit(dmg, time_rooted):
	hp -= dmg

func die():
	door.queue_free()

func get_interaction_time():
	if open == false:
		return interactiontime_close
	return interactiontime_open
	
func use():
	if animation_player.is_playing() != true:
		if open == false:
			animation_player.play("animation_open")
			audio_stream_player_3d.stream = sound_open
			audio_stream_player_3d.play(0.0)
			open = true
		else:
			animation_player.play("animation_close")
			audio_stream_player_3d.stream = sound_close
			audio_stream_player_3d.play(0.0)
			open = false
