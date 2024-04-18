extends Node3D

@onready var animation_player = $AnimationPlayer
#@onready var sound = $AnimationPlayer
@onready var barrel = $MeshInstance3D/RayCast3D
@onready var shell = preload("res://Scenes/shotgun_shell.tscn")
@onready var player = null
const RECOIL = 0#20
@onready var emitter_shell = $MeshInstance3D/GPUParticles3D
@onready var muzzleflash = $MeshInstance3D/muzzleflash/GPUParticles3D


@onready var pos_standard = Vector3(1.2,-0.6,-0.8)
@onready var pos_ads = Vector3(-0.03,-0.45,-0.5)

@onready var ads = 0 #0.. false 1..true
@onready var already = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	transform.origin = pos_standard

func _process(delta):
	if (ads == 1)&&(already== 0):
		#animation_player.play("ads")
		transform.origin = pos_ads
		already = 1
	elif (ads == 1) && (already == 1):
		
		pass
		
	elif ads == 0:
		if already == 1:
			#animation_player.play("RESET")
			transform.origin = pos_standard
			already = 0
		
	#print_debug("ads state: " + str(ads))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func shoot(inventory_selector,player_eyes_position):
		if animation_player.is_playing():
			pass
		else:		
			if player.inventory[inventory_selector].loaded > 0:
				player.inventory[inventory_selector].loaded -= 1
				animation_player.play("shoot")
				muzzleflash.set_emitting(true)
				muzzleflash.restart()
				for n in 6:
					var new_shell = shell.instantiate()
					new_shell.ads = ads
					new_shell.position = player_eyes_position
					new_shell.transform.basis = global_transform.basis
					get_tree().root.get_children()[0].add_child(new_shell);
				var goal_rotation = player.camera.rotation.x + deg_to_rad(RECOIL)
				player.camera.rotation.x = clamp(goal_rotation,deg_to_rad(-90),deg_to_rad(90))

func reload(inventory_selector):
	if animation_player.is_playing():
		pass
	else:
		animation_player.play("reload")
		emitter_shell.set_emitting(true)
		emitter_shell.restart()
		var space = player.inventory[inventory_selector].max_loaded-player.inventory[inventory_selector].loaded
		if space != 0:
			if player.inventory[inventory_selector].spare_ammo >= space:
				player.inventory[inventory_selector].loaded += space
				player.inventory[inventory_selector].spare_ammo -= 2
			else:
				player.inventory[inventory_selector].loaded += player.inventory[inventory_selector].spare_ammo
				player.inventory[inventory_selector].spare_ammo = 0
