extends Node3D

var dark_moon = null

# Called when the node enters the scene tree for the first time.
func _ready():
	dark_moon = get_tree().get_nodes_in_group("dark_moon")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	print("dark moon arise!!")
	if body.is_in_group("group_player"):
		
		dark_moon._rise()
