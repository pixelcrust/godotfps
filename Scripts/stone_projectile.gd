extends RigidBody3D

@onready var once = 0
@onready var throwing_multiplier = 9#12
@onready var model_stone = $MeshInstance3D
@onready var audio_stream_player_3d = $AudioStreamPlayer3D

const SOUND_EXPLOSION = preload("res://Sounds/explosion_large_07.wav")

signal signal_explosion()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#model_stone.mesh.set_layer_mask_value(1,true)
	#model_stone.mesh.set_layer_mask_value(2,false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(once == 0):
		apply_impulse(transform.basis.x *throwing_multiplier)
		once = 1


func _on_timer_timeout():
	queue_free()
