extends Node3D
@onready var interaction_time = .5

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
	"spare_ammo": 10
	})
	"""

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]


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
		"spare_ammo": spare_ammo
		})
		player.inventory_selector = len(player.inventory)-1
		if player.equipped_id != -1:
			player.equipped.queue_free()
		player.equip_weapon()
		queue_free()
	else:
		player.drop_weapon()
		player.inventory.append({
		"item_id": item_id, 
		"loaded": loaded,
		"max_loaded": max_loaded, 
		"spare_ammo": spare_ammo
		})
		player.inventory_selector = len(player.inventory)-1
		if player.equipped_id != -1:
			player.equipped.queue_free()
		player.equip_weapon()
		queue_free()
