extends Node3D

@onready var outline_mesh = $MeshInstance3D/MeshInstance3D
@onready var interaction_time = .01
var player = 0
@export var number_bullets = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_interaction_time():
	return interaction_time
	
func use():
	#check if gun is in inventory
	#for iteration in iterable_object:
	player.canvas_group.shaking = 0
	for n in player.inventory:
		#print(str(n.item_id))
		if n.item_id == 0:
			n.spare_ammo += number_bullets
			queue_free()
	#else dont pick up
	
	#pass
	
