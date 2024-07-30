extends Node3D
@onready var collision_shape_3d = $Area3D/CollisionShape3D

@export var night = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		if night == 1:
			collision_shape_3d.disabled = true
