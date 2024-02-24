extends Node3D

@onready var player = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	
	if body == player:
		player.in_water = true 
		print("player entererd")
	print(player.bone_head)

	if body == player.bone_head:
		player.under_water = true
		print("head entered")
	


func _on_area_3d_body_exited(body):
	if body == player:
		player.in_water = false
		print("player exited")
	if body == player.bone_head:
		player.under_water = false
		print("head exited")

func _on_area_3d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	pass
