extends Node3D

@onready var gpu_particles_3d: GPUParticles3D = $sniper_rifle/GPUParticles3D
@onready var sniper_rifle: Node3D = $"."

@onready var animation_player = $AnimationPlayer
@onready var mesh_instance_3d = $MeshInstance3D
@onready var sound = $AudioStreamPlayer3D
@onready var barrel = $sniper_rifle/RayCast3D
@onready var bullet = preload("res://Scenes/bullets/bullet_big.tscn")
@onready var player = null
@onready var zoom = 20
const RECOIL = 10#15

@onready var sound_shoot = preload("res://Sounds/sniper.wav")

@onready var pos_standard = Vector3(1.2,-0.6,-0.8)
@onready var pos_ads = Vector3(0.3,-0.45,-0.5)
#@onready var rotation_hipfire_y = deg_to_rad(-.3)
#@onready var rotation_ads

@onready var ads = 0 #0.. false 1..true
@onready var already = 0
var once = true
"""
inventory.append({
"item_id": 2, #sniper
"loaded": 1,
"max_loaded": 1, 
"spare_ammo": 10
})
"""
# Called when the node enters the scene tree for the first time.
func _ready():
	transform.origin = pos_standard
	#rotation.y = deg_to_rad(90)-rotation_hipfire_y
	visible = false

func _process(delta):
	if once == true:
		visible = true
		once = false
	print_debug("ads sniper: "+str(ads))
	if (ads == 1)&&(already== 0):
		#animation_player.play("ads")
		transform.origin = pos_ads
		#rotation.y = deg_to_rad(90)-rotation_hipfire_y
		#player.camera.zoom.y = 0.2
		already = 1
	elif (ads == 1) && (already == 1):
		if animation_player.is_playing()!= true:
			player.camera.fov = zoom
			sniper_rifle.visible = false
	elif ads == 0:
		if already == 1:
			#animation_player.play("RESET")
			transform.origin = pos_standard
			#rotation.y = deg_to_rad(90)
			sniper_rifle.visible = true
			already = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func shoot(inventory_selector,player_eyes,player_shot,collision_point):
	if animation_player.is_playing():
		pass
	else:
		if player.inventory[inventory_selector].loaded > 0:
			player.inventory[inventory_selector].loaded -= 1
			animation_player.play("shoot")
			sound.stream = sound_shoot
			sound.play(0.0)
			var new_bullet = bullet.instantiate()
			new_bullet.position = player_eyes.global_position
			new_bullet.transform.basis = global_transform.basis
			get_tree().root.get_children()[0].add_child(new_bullet)
			var goal_rotation = player.camera.rotation.x + deg_to_rad(RECOIL)
			player.camera.rotation.x = clamp(goal_rotation,deg_to_rad(-90),deg_to_rad(90))
			new_bullet.ads = ads
			new_bullet.player_shot = player_shot
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
