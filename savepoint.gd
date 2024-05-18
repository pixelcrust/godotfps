extends StaticBody3D

@onready var outline_mesh = $MeshInstance3D2
@onready var interactiontime = 3
@onready var player = 0
@onready var save_data = []

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	save_data.append(player.inventory)
	save_data.append(player.hp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_interaction_time():
	return interactiontime
	
func use():
	save_data.append(player.inventory)
	save_data.append(player.hp)
	save_data.append(position + Vector3(0,0,-2))
	print(save_data)
