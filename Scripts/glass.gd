extends Node3D
var hp_start = 1
var hp = hp_start
@onready var audio_stream_player_3d = $AudioStreamPlayer3D
@onready var sound_glass_break = preload("res://Sounds/EFX EXT Shattered Glass Impact 10 A.wav")
var once = 1
@onready var collision_shape_3d = $CollisionShape3D
@onready var mesh_instance_3d = $MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(hp <= 0):
		die()

func _on_physical_bone_3d_bodypart_hit(dmg, time_rooted):
	hp -= dmg

func die():
	if once == 1:
		once = 0
		print("hoi")
		audio_stream_player_3d.stream = sound_glass_break
		audio_stream_player_3d.play(0.0)
		collision_shape_3d.disabled = true
		mesh_instance_3d.visible = false
	await get_tree().create_timer(2).timeout
	queue_free()
