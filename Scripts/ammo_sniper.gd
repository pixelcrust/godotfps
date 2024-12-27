extends Node3D

@onready var outline_mesh = $RigidBody3D/ammo_sniper/MeshInstance3D
@onready var interaction_time = .01
var player = 0
@export var number_bullets = 5

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
	for n in player.inventory:
		#print(str(n.item_id))
		if n.item_id == 2:
			n.spare_ammo += number_bullets
			player.canvas_group.shaking = 0
			queue_free()
	#else dont pick up
	
	#pass
	
