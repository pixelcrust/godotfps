extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var player = null
@onready var ads = 0
@onready var creation_spot = $creation_spot
const grenade_thrown = preload("res://grenade_thrown.tscn")
const RECOIL = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(inventory_selector):
	
	if animation_player.is_playing():
		pass
	else:
		if player.inventory[inventory_selector].loaded > 0:

			player.inventory[inventory_selector].loaded -= 1
			animation_player.play("shoot")
			var new_grenade = grenade_thrown.instantiate()
			new_grenade.position = creation_spot.global_position
			new_grenade.transform.basis = global_transform.basis
			new_grenade.apply_impulse(-transform.basis.z *9)
			get_tree().root.get_children()[0].add_child(new_grenade);

			var goal_rotation = player.camera.rotation.x + deg_to_rad(RECOIL)
			player.camera.rotation.x = clamp(goal_rotation,deg_to_rad(-90),deg_to_rad(90))
			await get_tree().create_timer(0.5).timeout
		else:
			pass
		
func reload(inventory_selector):
	if animation_player.is_playing():
		pass
	else:
		pass
		#animation_player.play("reload") add easter egg
		

func _on_timer_timeout():
	pass
