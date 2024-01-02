extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var mesh_instance_3d = $MeshInstance3D
@onready var sound = $AudioStreamPlayer3D
@onready var barrel = $RayCast3D
@onready var bullet = preload("res://Scenes/bullet_big.tscn")
@onready var player = null
@onready var zoom = 20
const RECOIL = 15

@onready var ads = 0 #0.. false 1..true
@onready var already = 0

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
	pass # Replace with function body.


func _process(delta):
	if (ads == 1)&&(already== 0):
		animation_player.play("ads")
		
		#player.camera.zoom.y = 0.2
		already = 1
	elif (ads == 1) && (already == 1):
		if animation_player.is_playing()!= true:
			player.camera.fov = zoom
			mesh_instance_3d.visible = false
	elif ads == 0:
		if already == 1:
			animation_player.play("RESET")
			mesh_instance_3d.visible = true
			already = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func shoot(inventory_selector):
	if animation_player.is_playing():
		pass
	else:
		if player.inventory[inventory_selector].loaded > 0:
			player.inventory[inventory_selector].loaded -= 1
			animation_player.play("shoot")
			var new_bullet = bullet.instantiate()
			new_bullet.position = barrel.global_position
			new_bullet.transform.basis = global_transform.basis
			new_bullet.ads = ads
			get_tree().root.get_children()[0].add_child(new_bullet);
			var goal_rotation = player.camera.rotation.x + deg_to_rad(RECOIL)
			player.camera.rotation.x = clamp(goal_rotation,deg_to_rad(-90),deg_to_rad(90))
		else:
			pass
		
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
