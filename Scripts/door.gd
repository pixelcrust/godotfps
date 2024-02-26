extends MeshInstance3D

@onready var animation_player = $"../../AnimationPlayer"
@onready var door = $".."
@onready var outline_mesh = $MeshInstance3D
@onready var audio_stream_player_3d = $"../../AudioStreamPlayer3D"
@onready var sound_close = preload("res://Models/Sounds/door close 12.wav")
@onready var sound_open = preload("res://Models/Sounds/door open 4.wav")

const HP_START = 100
@onready var hp = HP_START
@export var state = 0
#0.. closed
#1.. open

@onready var interactiontime_open = .01
@onready var interactiontime_close = .01

# Called when the node enters the scene tree for the first time.
func _ready():
	if state == 0:
		animation_player.play("animation_close")
		audio_stream_player_3d.stream = sound_close
		#audio_stream_player_3d.
	elif state == 1:
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
	if state == 0:
		return interactiontime_close
	return interactiontime_open
	
func use():
	if animation_player.is_playing() != true:
		if state == 0:
			animation_player.play("animation_open")
			state = 1
		else:
			animation_player.play("animation_close")
			state = 0
