extends RigidBody3D

@onready var once = 0
@onready var throwing_multiplier = 12
@onready var timer = $Timer
@onready var model_pipebomb = $pipebomb


signal signal_explosion()
# Called when the node enters the scene tree for the first time.
func _ready():
	model_pipebomb.mesh.set_layer_mask_value(1,true)
	model_pipebomb.mesh.set_layer_mask_value(2,false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(once == 0):
		timer.start()
		apply_impulse(-transform.basis.z *throwing_multiplier)
		once = 1


func _on_timer_timeout():
	emit_signal("signal_explosion")
	await get_tree().create_timer(10.0).timeout
	queue_free()
