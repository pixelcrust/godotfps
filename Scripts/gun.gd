extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var sound = $AudioStreamPlayer
@onready var barrel = $MeshInstance3D/RayCast3D
@onready var bullet = preload("res://Scenes/bullet.tscn")
@onready var sound_shoot = preload("res://Models/Sounds/sfx_weapon_singleshot21.wav")
@onready var player = null
@onready var emitter_shell = $MeshInstance3D/emitter_shell/GPUParticles3D


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
			emitter_shell.set_emitting(true)
			emitter_shell.restart()
			var new_bullet = bullet.instantiate()
			new_bullet.position = barrel.global_position
			new_bullet.transform.basis = global_transform.basis
			get_tree().root.get_children()[0].add_child(new_bullet);
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

func _on_timer_timeout():
	pass