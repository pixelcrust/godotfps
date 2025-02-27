extends Node3D
@onready var interaction_time = .5
@onready var model_flashlight = $RigidBody3D/flashlight1

@onready var rigid_body = $RigidBody3D
@onready var outline_mesh = $RigidBody3D/flashlight1.outline_mesh

@onready var player = 0
const item_id = 4
@onready var loaded = 1
const max_loaded = 1
@onready var spare_ammo = 0
"""
	inventory.append({
	"item_id": 3, #knife
	"loaded": 1,
	"max_loaded": 1, # See above assignment.
	"spare_ammo": 0,
	"icon": preload("res://Sprites/icons/icon_flashlight.png")
	})
	"""

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	#print_debug(model_pistol.mesh.get_layer_mask_value(2))
	model_flashlight.mesh.set_layer_mask_value(1,true)
	model_flashlight.mesh.set_layer_mask_value(2,false)
	
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
		"icon": preload("res://Sprites/icons/icon_flashlight.png")
		})
		"""
		player.inventory_selector = len(player.inventory)-1
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
		"icon": preload("res://Sprites/icons/icon_flashlight.png")
		})
		"""
		player.inventory_selector = len(player.inventory)-1
		if player.equipped_id != -1:
			player.equipped.queue_free()
		player.equip_weapon()"""
		queue_free()
