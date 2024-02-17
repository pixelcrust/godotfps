extends Node3D

@onready var once = 0
@onready var interactiontime = .01
@onready var player = 0
@onready var area_3d = $Area3D

@onready var asset_ladder_tile = preload("res://ladder_tile.tscn")
@onready var mesh_instance_3d = $MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0] # Replace with function body.
	#create tiled ladder
	mesh_instance_3d.queue_free()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if once == 0:
		var number_of_tiles = floor(scale.y)
		for n in number_of_tiles:
			print(str(n))
			var new_ladder_tile = asset_ladder_tile.instantiate()
			new_ladder_tile.position = global_position + Vector3(-.15,(-n)*1.69+number_of_tiles/2,.35)#+ Vector3(-.15,-n*1.69,.35)
			new_ladder_tile.rotation = rotation
			#new_ladder_tile.transform.basis = global_transform.basis
			get_tree().root.get_children()[0].add_child(new_ladder_tile)
			once = 1

func get_interaction_time():
	return interactiontime
	
func use():
	#check if in area
	
	print("interacted with ladder")
	if player.interacted_with_ladder == false:
		player.interacted_with_ladder = true
	else:
		player.interacted_with_ladder = false


func _on_area_3d_body_entered(body):
	print("body entered")
	if body == player:
		player.is_on_ladder = true # Replace with function body.



func _on_area_3d_body_exited(body):
	if body == player:
		player.is_on_ladder = false
		player.interacted_with_ladder = false


