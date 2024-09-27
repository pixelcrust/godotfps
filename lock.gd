extends Node3D

signal unlock_door()

@onready var hp = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hp <= 0:
		die()


func _on_physical_bone_3d_bodypart_hit(dmg: Variant, time_rooted: Variant) -> void:
	hp -= dmg
	print("hp left: "+str(hp))

func die():
	emit_signal("unlock_door")
	queue_free()
