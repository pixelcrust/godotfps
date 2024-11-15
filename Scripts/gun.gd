extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player_3d = $AudioStreamPlayer3D
@onready var barrel = $Node3D/hand_right/model_pistol/RayCast3D
@onready var bullet = preload("res://Scenes/bullets/bullet.tscn")

#sounds
@onready var sound_shoot = preload("res://Sounds/gun.wav")
@onready var sound_empty = preload("res://Sounds/gun fired no bullets 3.wav")
@onready var sound_reloading = preload("res://Sounds/gun movement 27.wav")

@onready var player = null
@onready var emitter_shell = $Node3D/hand_right/model_pistol/emitter_shell/GPUParticles3D
@onready var muzzleflash = $Node3D/hand_right/model_pistol/muzzleflash/GPUParticles3D
@onready var hands = $Node3D


const RECOIL = 2#5
@onready var pos_standard = Vector3(-0.20,-0.10,0.40)
@onready var pos_ads = Vector3(-0.70,0.30,-1.17)
#@onready var pos_change_in = Vector3(-1.0,0,0)
#@onready var rotation_standard = Vector3(0,0,deg_to_rad(-90))
#@onready var rotation_start = Vector3(0,0,-90)

@onready var ads = 0 #0.. false 1..true
@onready var already = 0
@onready var once = true
# Called when the node enters the scene tree for the first time.
func _ready():
	hands.transform.origin = pos_standard
	visible = false
	#hands.rotation = rotation_start


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if once == true:
		visible = true
		once = false
	#hands.rotation = rotation_standard
	if (ads == 1)&&(already== 0):
		#animation_player.play("ads")
		hands.transform.origin = pos_ads
		already = 1
	elif (ads == 1) && (already == 1):
		
		pass
		
	elif ads == 0:
		if already == 1:
			#animation_player.play("RESET")
			hands.transform.origin = pos_standard

			already = 0
		
	#print_debug("ads gun state: " + str(ads))
	
func shoot(inventory_selector,player_eyes,player_shot,collision_point):
	if animation_player.is_playing():
		pass
	else:
		if player.inventory[inventory_selector].loaded > 0:
			player.inventory[inventory_selector].loaded -= 1
			animation_player.play("shoot")
			audio_stream_player_3d.stream = sound_shoot
			audio_stream_player_3d.play(0.0)
			muzzleflash.set_emitting(true)
			muzzleflash.restart()
			emitter_shell.set_emitting(true)
			emitter_shell.restart()
			
			"""if target_on_raycast != null:
				aim_helper.look_at(target_on_raycast,Vector3.UP)
				
				new_bullet.position = aim_helper.global_position
				new_bullet.transform.basis = aim_helper.global_transform.basis
				new_bullet.rotate_y(deg_to_rad(90))
				print("shot with aim helper")
			else:
				new_bullet.position = barrel.global_position
				new_bullet.transform.basis = global_transform.basis
				print("shot without aim helper")"""
			
			var new_bullet = bullet.instantiate()
			new_bullet.position = player_eyes.global_position
			new_bullet.transform.basis = global_transform.basis
			#new_bullet.transform.basis = player_eyes.global_transform.basis
			#new_bullet.rotate_y(deg_to_rad(90))
			#new_bullet.target = collision_point
			get_tree().root.get_children()[0].add_child(new_bullet)
			
			#set bullet variables
			new_bullet.ads = ads
			new_bullet.player_shot = player_shot
			
			#recoil to the camera
			var goal_rotation = player.camera.rotation.x + deg_to_rad(RECOIL)
			player.camera.rotation.x = clamp(goal_rotation,deg_to_rad(-90),deg_to_rad(90))
			await get_tree().create_timer(0.5).timeout
			
		else:
			audio_stream_player_3d.stream = sound_empty
			audio_stream_player_3d.play(0.0)
			animation_player.play("shoot_empty")
		
func reload(inventory_selector):
	if animation_player.is_playing():
		pass
	else:
		audio_stream_player_3d.stream = sound_reloading
		audio_stream_player_3d.play(0.0)
		animation_player.play("reload")
		var space = player.inventory[inventory_selector].max_loaded-player.inventory[inventory_selector].loaded
		if space != 0:
			var reload_amount = min(space, player.inventory[inventory_selector].spare_ammo)
			player.inventory[inventory_selector].loaded += reload_amount
			player.inventory[inventory_selector].spare_ammo -= reload_amount

func inspect():
	if animation_player.is_playing():
		pass
	else:
		animation_player.play("inspect")
func _on_timer_timeout():
	pass
