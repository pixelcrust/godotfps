extends Node3D
@onready var hp_start = 10
@onready var hp = hp_start
@onready var emitter = $explosion

signal signal_explosion()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hp <= 0:
		dying()

func dying():
	emit_signal("signal_explosion")
	await get_tree().create_timer(1.0).timeout
	queue_free()


func _on_timer_timeout():
	queue_free()
	


func _on_physical_bone_3d_bodypart_hit(dmg):
	hp -= dmg
