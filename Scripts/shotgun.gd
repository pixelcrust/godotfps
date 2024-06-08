extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var shotgun = $shotgun

#@onready var sound = $AnimationPlayer
@onready var barrel = $shotgun/RayCast3D
@onready var shell = preload("res://Scenes/shotgun_shell.tscn")
@onready var player = null
const RECOIL = 0#20
@onready var emitter_shell = $shotgun/GPUParticles3D
@onready var muzzleflash = $shotgun/muzzleflash/GPUParticles3D


@onready var pos_standard = Vector3(0.4,-0.6,-1.4)
@onready var pos_ads = Vector3(-0.1,-0.3,-0.9)

@onready var ads = 0 #0.. false 1..true
@onready var already = 0
var once = true

# Called when the node enters the scene tree for the first time.
func _ready():
	transform.origin = pos_standard
	visible = false

func _process(delta):
	if once == true:
		visible = true
		once = false
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
func shoot(inventory_selector,player_eyes,player_shot,collision_point):
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
					new_shell.position = player_eyes.global_position #+ Vector3(.5,0,0)
					new_shell.transform.basis = global_transform.basis
					get_tree().root.get_children()[0].add_child(new_shell)
					new_shell.player_shot = player_shot
				var goal_rotation = player.camera.rotation.x + deg_to_rad(RECOIL)
				player.camera.rotation.x = clamp(goal_rotation,deg_to_rad(-90),deg_to_rad(90))

func reload(inventory_selector):
	if animation_player.is_playing():
		pass
	else:
		animation_player.play("reload")

		var space = player.inventory[inventory_selector].max_loaded-player.inventory[inventory_selector].loaded
		if space != 0:
			if player.inventory[inventory_selector].spare_ammo != 0 and player.inventory[inventory_selector].loaded != 0:
				emitter_shell.set_emitting(true)
				emitter_shell.restart()
			if player.inventory[inventory_selector].spare_ammo >= space:
				player.inventory[inventory_selector].loaded += space
				player.inventory[inventory_selector].spare_ammo -= 2
			else:
				player.inventory[inventory_selector].loaded += player.inventory[inventory_selector].spare_ammo
				player.inventory[inventory_selector].spare_ammo = 0
func inspect():
	if animation_player.is_playing():
		pass
	else:
		animation_player.play("inspect")
