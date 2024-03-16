extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var player = null
@onready var ads = 0
@onready var creation_spot = $creation_spot
@onready var model_pipebomb = $Node3D/hand_right/model_pipebomb
@onready var hands = $Node3D

@onready var pos_standard = Vector3(-0.70,-0.10,0.60)

const grenade_thrown = preload("res://Scenes/grenade_thrown.tscn")
const RECOIL = -5

# Called when the node enters the scene tree for the first time.
func _ready():
	hands.transform.origin = pos_standard


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(inventory_selector,target_on_raycast):
	
	if animation_player.is_playing():
		pass
	else:
		if player.inventory[inventory_selector].loaded > 0:


			animation_player.play("shoot")
			await get_tree().create_timer(.5).timeout
			var new_grenade = grenade_thrown.instantiate()
			new_grenade.position = creation_spot.global_position
			new_grenade.transform.basis = global_transform.basis
			model_pipebomb.visible = false
			get_tree().root.get_children()[0].add_child(new_grenade);
			var direction = null
			"""if(target_on_raycast!= null):
				direction = abs(target_on_raycast - position)
			else:
				direction = position + Vector3(0,0,-10)
			#new_grenade.apply_impulse(direction.z)
			print(direction)"""
			var goal_rotation = player.camera.rotation.x + deg_to_rad(RECOIL)
			player.camera.rotation.x = clamp(goal_rotation,deg_to_rad(-90),deg_to_rad(90))
			
			player.inventory[inventory_selector].loaded -= 1
		else:
			pass
		
func reload(inventory_selector):
	if animation_player.is_playing():
		pass
	else:
		animation_player.play("reload")
		
		
func inspect():
	if animation_player.is_playing():
		pass
	else:
		animation_player.play("inspect")
func _on_timer_timeout():
	pass
