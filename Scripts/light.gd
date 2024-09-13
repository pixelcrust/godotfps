extends Node3D

var hp_start = 1
var hp = hp_start

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hp <= 0:
		die()

func die():
	queue_free()


func _on_physical_bone_3d_bodypart_hit(dmg, time_rooted):
	hp -= dmg
