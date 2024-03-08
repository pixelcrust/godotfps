extends RigidBody3D

@onready var once = 0
@onready var throwing_multiplier = 12
@onready var timer = $Timer

signal signal_explosion()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
