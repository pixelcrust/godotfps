extends Node3D

@onready var interaction_time = 1.5

@onready var player = 0
const item_id = 0

@onready var outline_mesh = $MeshInstance3D/MeshInstance3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var spin_speed = 0.01
	rotation.y += spin_speed

func get_interaction_time():
	return interaction_time

func use():
		queue_free()
