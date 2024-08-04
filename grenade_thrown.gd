extends RigidBody3D

@onready var once = 0
@onready var once2 = 0
@onready var throwing_multiplier = 12
@onready var timer = $Timer
@onready var model_pipebomb = $pipebomb
@onready var audio_stream_player_3d = $AudioStreamPlayer3D
const SOUND_EXPLOSION = preload("res://Sounds/explosion_large_07.wav")

signal signal_explosion()
# Called when the node enters the scene tree for the first time.
func _ready():
	model_pipebomb.mesh.set_layer_mask_value(1,true)
	model_pipebomb.mesh.set_layer_mask_value(2,false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(once == 0):
		timer.start()
		apply_impulse(transform.basis.x *throwing_multiplier)
		once = 1


func _on_timer_timeout():
	if once2 == 0:
		audio_stream_player_3d.stream = SOUND_EXPLOSION
		audio_stream_player_3d.play(0.0)
		once2 = 1
	emit_signal("signal_explosion")
	await get_tree().create_timer(10.0).timeout
	queue_free()
