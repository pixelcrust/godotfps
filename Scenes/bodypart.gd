extends PhysicalBone3D


@export var damage_multiplier = 1

signal bodypart_hit(dmg)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(dmg):
	emit_signal("bodypart_hit",dmg*damage_multiplier)
