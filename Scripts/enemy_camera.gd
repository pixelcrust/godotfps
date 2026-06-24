extends Node3D


var player = null

var direction = 0
var turn_speed_horizontally = 30

var hp_start = 100
var hp = hp_start


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player_root")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hp <= 0:
		die()


func _on_physical_bone_3d_bodypart_hit(dmg, time_rooted):
	hp -= dmg
	print("hp left: "+str(hp))

func die():
	queue_free()
