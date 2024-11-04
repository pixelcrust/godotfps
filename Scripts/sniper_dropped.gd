extends Node3D
@onready var interaction_time = .5
@onready var outline_mesh = $RigidBody3D/sniper_rifle.outline_mesh
@onready var sniper: Node3D = $RigidBody3D/sniper_rifle

@onready var rigid_body = $RigidBody3D

@onready var player = 0
const item_id = 2
@export var loaded = 1
const max_loaded = 1
@export var spare_ammo = 10
"""
	inventory.append({
	"item_id": 2, #sniper
	"loaded": 5,
	"max_loaded": 5, 
	"spare_ammo": 10,
	"icon": preload("res://Sprites/icons/icon_sniper.png")
	})
	"""

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	sniper.stock.set_layer_mask_value(1,true)
	sniper.stock.set_layer_mask_value(2,false)
	sniper.lauf.set_layer_mask_value(1,true)
	sniper.lauf.set_layer_mask_value(2,false)
	sniper.trigger.set_layer_mask_value(1,true)
	sniper.trigger.set_layer_mask_value(2,false)
	sniper.kimme.set_layer_mask_value(1,true)
	sniper.kimme.set_layer_mask_value(2,false)
	sniper.korn.set_layer_mask_value(1,true)
	sniper.korn.set_layer_mask_value(2,false)
	sniper.stopsel.set_layer_mask_value(1,true)
	sniper.stopsel.set_layer_mask_value(2,false)
	sniper.lader.set_layer_mask_value(1,true)
	sniper.lader.set_layer_mask_value(2,false)
	sniper.cube.set_layer_mask_value(1,true)
	sniper.cube.set_layer_mask_value(2,false)
	sniper.cube_001.set_layer_mask_value(1,true)
	sniper.cube_001.set_layer_mask_value(2,false)
	sniper.cylinder.set_layer_mask_value(1,true)
	sniper.cylinder.set_layer_mask_value(2,false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_interaction_time():
	return interaction_time

func use():
	if len(player.inventory) < player.inventory_space:
		player.inventory.append({
		"item_id": item_id, #sniper
		"loaded": loaded,
		"max_loaded": max_loaded, 
		"spare_ammo": spare_ammo,
		"icon": preload("res://Sprites/icons/icon_sniper.png")
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
		"icon": preload("res://Sprites/icons/icon_sniper.png")
		})
		"""player.inventory_selector = len(player.inventory)-1
		if player.equipped_id != -1:
			player.equipped.queue_free()
		player.equip_weapon()"""
		queue_free()
