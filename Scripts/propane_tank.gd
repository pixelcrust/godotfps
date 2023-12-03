extends Node3D
@onready var hp_start = 10
@onready var hp = hp_start
@onready var emitter = $RigidBody3D/explosion
@onready var once = 0
@onready var mesh = $RigidBody3D/MeshInstance3D


signal signal_explosion()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hp <= 0:
		dying()

func dying():
	#mesh.visible = false
	if once == 0:
		emit_signal("signal_explosion")
		once = 1
	await get_tree().create_timer(10.0).timeout
	queue_free()


func _on_timer_timeout():
	queue_free()
	


func _on_physical_bone_3d_bodypart_hit(dmg,time_rooted):
	hp -= dmg
