extends Area3D

@onready var object = $".."
@onready var array = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_outline_meshes():
	array.clear()
	array.append(object)
	return array
