extends MeshInstance3D

const HP_START = 100
@onready var hp = HP_START
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
	queue_free()
