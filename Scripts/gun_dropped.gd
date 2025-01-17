extends Node3D
@onready var interaction_time = .5

@onready var model_pistol = $RigidBody3D/model_pistol
@onready var rigid_body = $RigidBody3D
@onready var outline_mesh = $RigidBody3D/model_pistol.outline_mesh


@onready var player = 0
const item_id = 0
@export var loaded = 7
const max_loaded = 7
@export var spare_ammo = 10

"""
	inventory.append({
	"item_id": 0, #pistol
	"loaded": 7,
	"max_loaded": 7, # See above assignment.
	"spare_ammo": 100,
	"icon": preload("res://Sprites/icons/icon_pistol_2.png")
	})
	"""

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	#print_debug(model_pistol.mesh.get_layer_mask_value(2))
	model_pistol.mesh.set_layer_mask_value(1,true)
	model_pistol.mesh.set_layer_mask_value(2,false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_interaction_time():
	return interaction_time

func use():
	if len(player.inventory) < player.inventory_space:
		player.inventory.append({
		"item_id": item_id, 
		"loaded": loaded,
		"max_loaded": max_loaded, 
		"spare_ammo": spare_ammo,
		"icon": preload("res://Sprites/icons/icon_pistol_2.png")
		})
		"""player.inventory_selector = len(player.inventory)-1
		if player.equipped_id != -1:
			player.equipped.queue_free()
		player.equip_weapon()"""
		queue_free()
	else:
		player.drop_weapon()
		player.inventory.append({
		"item_id": item_id, 
		"loaded": loaded,
		"max_loaded": max_loaded, 
		"spare_ammo": spare_ammo,
		"icon": preload("res://Sprites/icons/icon_pistol_2.png")
		})
		"""player.inventory_selector = len(player.inventory)-1
		if player.equipped_id != -1:
			player.equipped.queue_free()
		player.equip_weapon()"""
		queue_free()
