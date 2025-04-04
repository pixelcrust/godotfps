extends PhysicalBone3D

@onready var object = $".."

@onready var array = []
@export var damage_multiplier = 1

signal bodypart_hit(dmg,time_rooted)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(dmg,time_rooted):
	emit_signal("bodypart_hit",dmg*damage_multiplier,time_rooted)
	print("hit for "+str(dmg))

func get_outline_meshes():
	array.clear()
	array.append(object)
	return array
