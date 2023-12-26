extends Node3D

@onready var animation_player = $AnimationPlayer
#@onready var sound = $AnimationPlayer
@onready var barrel = $MeshInstance3D/RayCast3D
@onready var shell = preload("res://Scenes/shotgun_shell.tscn")
@onready var player = null
const RECOIL = 20

@onready var ads = 0 #0.. false 1..true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func shoot(inventory_selector):
		if animation_player.is_playing():
			pass
		else:		
			if player.inventory[inventory_selector].loaded > 0:
				player.inventory[inventory_selector].loaded -= 1
				animation_player.play("shoot")
				for n in 6:
					var new_shell = shell.instantiate()
					new_shell.position = barrel.global_position
					new_shell.transform.basis = global_transform.basis
					get_tree().root.get_children()[0].add_child(new_shell);
				var goal_rotation = player.camera.rotation.x + deg_to_rad(RECOIL)
				player.camera.rotation.x = clamp(goal_rotation,deg_to_rad(-90),deg_to_rad(90))

func reload(inventory_selector):
	if animation_player.is_playing():
		pass
	else:
		animation_player.play("reload")
		var space = player.inventory[inventory_selector].max_loaded-player.inventory[inventory_selector].loaded
		if space != 0:
			if player.inventory[inventory_selector].spare_ammo >= space:
				player.inventory[inventory_selector].loaded += space
				player.inventory[inventory_selector].spare_ammo -= space
			else:
				player.inventory[inventory_selector].loaded += player.inventory[inventory_selector].spare_ammo
				player.inventory[inventory_selector].spare_ammo = 0	
