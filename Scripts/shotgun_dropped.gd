extends Node3D
@onready var interaction_time = .5
@onready var rigid_body = $RigidBody3D
#@onready var outline_mesh = $RigidBody3D/MeshInstance3D/MeshInstance3D
@onready var shotgun = $RigidBody3D/shotgun


@onready var player = 0
const item_id = 1
@export var loaded = 2
const max_loaded = 2
@export var spare_ammo = 8
"""
	inventory.append({
	"item_id": 1, #shotgun
	"loaded": 2,
	"max_loaded": 2, 
	"spare_ammo": 4,
	"icon": preload("res://Sprites/icons/icon_shotgun.png")
	})
	"""

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	shotgun.mesh1.set_layer_mask_value(1,true)
	shotgun.mesh1.set_layer_mask_value(2,false)
	shotgun.mesh2.set_layer_mask_value(1,true)
	shotgun.mesh2.set_layer_mask_value(2,false)

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
		"icon": preload("res://Sprites/icons/icon_shotgun.png")
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
		"icon": preload("res://Sprites/icons/icon_shotgun.png")
		})
		"""player.inventory_selector = len(player.inventory)-1
		if player.equipped_id != -1:
			player.equipped.queue_free()
		player.equip_weapon()"""
		queue_free()
