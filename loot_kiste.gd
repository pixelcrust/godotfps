extends StaticBody3D

@onready var outline_mesh = $MeshInstance3D/MeshInstance3D
var interaction_time = 1
@export var item_id = 0
var drop = null
var random: Array[int] = [0,1,2,3,4,5,99,98]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_id = random.pick_random()
	match item_id:
		0:
			drop = preload("res://Scenes/pickups/gun_dropped.tscn")
		1:
			drop = preload("res://Scenes/pickups/shotgun_dropped.tscn")
		2:
			drop = preload("res://Scenes/pickups/sniper_dropped.tscn")
		3:
			drop = preload("res://Scenes/pickups/knife_dropped.tscn")
		4:
			drop = preload("res://Scenes/pickups/flashlight_dropped.tscn")
		5:
			drop = preload("res://Scenes/pickups/grenade_dropped.tscn")
		99:
			drop = preload("res://Scenes/pickups/ammo_pistol.tscn")
		98:
			drop = preload("res://Scenes/pickups/ammo_shotgun.tscn")
		_:
			drop = preload("res://Scenes/pickups/grenade_dropped.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_interaction_time():
	return interaction_time
	
func use():
	var new_drop = drop.instantiate()
	new_drop.position = global_position
	new_drop.transform.basis = global_transform.basis
	get_tree().root.get_children()[0].add_child(new_drop)
	queue_free()
