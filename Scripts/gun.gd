extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var sound = $AudioStreamPlayer
@onready var barrel = $Node3D/hand_right/model_pistol/RayCast3D
@onready var bullet = preload("res://Scenes/bullet.tscn")
@onready var sound_shoot = preload("res://Sounds/sfx_weapon_singleshot21.wav")
@onready var player = null
@onready var emitter_shell = $Node3D/hand_right/model_pistol/emitter_shell/GPUParticles3D
@onready var muzzleflash = $Node3D/hand_right/model_pistol/muzzleflash/GPUParticles3D
@onready var aim_helper = $Node3D/hand_right/model_pistol/aim_helper
@onready var hands = $Node3D



const RECOIL = 5
@onready var pos_standard = Vector3(-0.20,-0.10,0.40)
@onready var pos_ads = Vector3(-0.70,0.30,-1.17)
@onready var rotation_standard = Vector3(0,0,0)
@onready var rotation_ads = Vector3(0,0,0)

@onready var ads = 0 #0.. false 1..true
@onready var already = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	hands.transform.origin = pos_standard
	hands.rotation = rotation_standard


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (ads == 1)&&(already== 0):
		#animation_player.play("ads")
		hands.transform.origin = pos_ads
		hands.rotation = rotation_ads
		already = 1
	elif (ads == 1) && (already == 1):
		
		pass
		
	elif ads == 0:
		if already == 1:
			#animation_player.play("RESET")
			hands.transform.origin = pos_standard
			hands.rotation = rotation_standard
			already = 0
		
	#print_debug("ads gun state: " + str(ads))
	
func shoot(inventory_selector,target_on_raycast):
	
	if animation_player.is_playing():
		pass
	else:
		if player.inventory[inventory_selector].loaded > 0:
			player.inventory[inventory_selector].loaded -= 1
			animation_player.play("shoot")
			muzzleflash.set_emitting(true)
			muzzleflash.restart()
			emitter_shell.set_emitting(true)
			emitter_shell.restart()
			var new_bullet = bullet.instantiate()
			if target_on_raycast != null:
				aim_helper.look_at(target_on_raycast)
				new_bullet.position = aim_helper.global_position
				print("shot with aim helper")
			else:
				new_bullet.position = barrel.global_position
			new_bullet.transform.basis = global_transform.basis
			get_tree().root.get_children()[0].add_child(new_bullet)
			new_bullet.ads = ads
			var goal_rotation = player.camera.rotation.x + deg_to_rad(RECOIL)
			player.camera.rotation.x = clamp(goal_rotation,deg_to_rad(-90),deg_to_rad(90))
			await get_tree().create_timer(0.5).timeout
			
		else:
			pass
		
func reload(inventory_selector):
	if animation_player.is_playing():
		pass
	else:
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
