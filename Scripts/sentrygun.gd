extends Node3D

@onready var gun = $gun
@onready var ray_cast_3d = $gun/barrel/RayCast3D
@onready var laser = $gun/barrel/RayCast3D/laser
@onready var aim_helper = $gun/barrel/aim_helper
@onready var bullet = preload("res://Scenes/bullets/bullet.tscn")
@onready var muzzleflash = $gun/barrel/muzzleflash/GPUParticles3D

#sound
@onready var audio_stream_player_3d = $AudioStreamPlayer3D
@onready var sound_shoot = preload("res://Sounds/gun.wav")
const sound_searching = preload("res://Sounds/Atari PC2 - Floppy Failure 3.wav")


@onready var timer_shooting = $Timer
var cd_bullet = 25

var horizontal_shooting_error_range = 0
var vertical_shooting_error_range = 0
var player = null
@export var turn_speed_scouting = 60
var turn_speed_horizontally = 30
var direction = 0
var hp_start = 100
var hp = hp_start

@onready var state = 2
"""0 idle
	1 aim directly
	2 shoot at player
	3 wait to move back if not again collision
	4 move back to start
	"""

@onready var time_aiming = 120
@onready var time_between_bullets = 10
@export var angle_range = 50
@onready var start_pos = transform.origin
var current_angle = 0
var going_left = true
var is_shooting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if hp <= 0:
		die()
	
	aim_helper.look_at(Vector3(player.global_position.x, player.global_position.y,player.global_position.z),Vector3.UP)
	gun.rotation.z = aim_helper.rotation.z 
	gun.rotation.x = aim_helper.rotation.x
	gun.rotation.y = aim_helper.rotation.y
	
	match state:
		0:
			pass
		1:
			pass
		2: #shoot at player
			shoot(1)
			pass
"""
	var target = player.global_position#ray_cast_3d.get_collision_point()
	
	#print("state: "+ str(state))
	match state:
		0:
			#print("current_angle: "+str(current_angle)+ " angle_range: "+str(angle_range))
			#print("going left: "+str(going_left))
			audio_stream_player_3d.stream = sound_searching
			audio_stream_player_3d.play(0.0)
			if going_left == true:
				current_angle += delta*turn_speed_scouting
				if current_angle >= angle_range:
					going_left = false
					#print("current angle bigger!!!!!!!!!!!!!!!!")
			else:
				current_angle -= delta*turn_speed_scouting
				if current_angle <= 0:
					going_left = true
			gun.rotation.y=(deg_to_rad(current_angle))
			if current_angle >= 360:
				current_angle = 0
			#if spott player
			if ray_cast_3d.is_colliding():
				if ray_cast_3d.get_collider() != null:
					if ray_cast_3d.get_collider().is_in_group("has_blood"):
						state = 1
					#pass
		1:#state follow player
			#return to state 0
			aim_helper.look_at(target)
			aim(delta)
			#rotation.z = aim_helper.rotation.z
			#rotation.y = aim_helper.rotation.y
			if ray_cast_3d.is_colliding() == false:
				state = 3
				#pass
			else:
				if ray_cast_3d.get_collider().is_in_group("has_blood") == false:
					state = 3
					#pass
				else:
					#pass
					#await get_tree().create_timer(1).timeout
					state = 2
		2:	#shoot
			if is_shooting == false:
				shoot(1)
				is_shooting = true
			#await get_tree().create_timer(3).timeout
			#if ray_cast_3d.get_collider().is_in_group("has_blood") == false:
			state = 1
		3: #wait until moving back
			if ray_cast_3d.get_collider() != null:
				if ray_cast_3d.get_collider().is_in_group("has_blood") == false:
					if ray_cast_3d.get_collider() != null:
						#await get_tree().create_timer(1).timeout
						state = 4
				else:
					#await get_tree().create_timer(3).timeout
					state = 2
		4: #move back to starting position
			transform.origin = start_pos
			gun.rotation.x = 0
			gun.rotation.y = 0
			state = 0
		_:
			pass
			"""
func aim(delta):
	"""
	#uses the player not the collision with raycast
	# aiming from the arm of the enemy to the head of the player
	var global_pos1 = gun.global_transform.origin
	var global_pos2 = player.head.global_transform.origin

	# Calculate the vector between the two nodes
	direction = global_pos2 - global_pos1
	
	# Calculate the vertical angle (angle in the Y-axis)
	var vertical_angle = atan2(direction.y, abs(direction.x))
	#print_debug(rad_to_deg(vertical_angle))
	#gun.rotation.x = clamp(-vertical_angle,-30,30) #+ deg_to_rad(randi_range(-vertical_shooting_error_range,vertical_shooting_error_range))
	aim_helper.look_at(player.global_transform.origin,Vector3.UP)
	var ray_collider = ray_cast_3d.get_collider()
	var vertical_angle_to_player = 0
	
	
	
	if( ray_collider != player):
		rotate_y(-deg_to_rad(aim_helper.rotation.y * turn_speed_horizontally*delta))
		##arm.rotate_z(deg_to_rad(dir_to_player) * turn_speed_horizontally*delta)
		var ray_gun_collider = ray_cast_3d.get_collider()
		
	else:
		#timer.start()
		#print("raycastcollider:"+str(ray_view.get_collider())+".... player:"+str(player))
		pass
		"""
func shoot(number_bullets):
	await get_tree().create_timer(1).timeout
	timer_shooting.start()
	muzzleflash.set_emitting(true)
	muzzleflash.restart()
	audio_stream_player_3d.stream = sound_shoot
	audio_stream_player_3d.play(0.0)
	var new_bullet = bullet.instantiate()
	new_bullet.position = aim_helper.global_position + Vector3(0,0,1)
	new_bullet.transform.basis = aim_helper.global_transform.basis
	new_bullet.ads = 1
	new_bullet.rotation.y = aim_helper.rotation.y+deg_to_rad(-90)+randi_range(-horizontal_shooting_error_range,horizontal_shooting_error_range)+deg_to_rad(90)
	new_bullet.rotation.z = aim_helper.rotation.z+randi_range(-vertical_shooting_error_range,vertical_shooting_error_range)
	new_bullet.rotation.x = aim_helper.rotation.x
	get_tree().root.get_children()[0].add_child(new_bullet)

	
	#print("arm rotation.z: "+str(rad_to_deg(arm.rotation.z))+"body_rotation: "+str(rad_to_deg(rotation.y)))
	#await get_tree().create_timer(3).timeout
	"""
	timer_shooting.start()
	muzzleflash.set_emitting(true)
	muzzleflash.restart()
	for i in number_bullets:
		audio_stream_player_3d.stream = sound_shoot
		audio_stream_player_3d.play(0.0)
		var new_bullet = bullet.instantiate()
		new_bullet.position = aim_helper.global_position
		new_bullet.transform.basis = aim_helper.global_transform.basis
		new_bullet.rotation.y = new_bullet.rotation.y+deg_to_rad(90)+randi_range(-horizontal_shooting_error_range,horizontal_shooting_error_range)
		new_bullet.rotation.z = new_bullet.rotation.z+randi_range(-vertical_shooting_error_range,vertical_shooting_error_range)
		new_bullet.ads = 1
		get_tree().root.get_children()[0].add_child(new_bullet);"""


func _on_physical_bone_3d_bodypart_hit(dmg, time_rooted):
	hp -= dmg
	print("hp left: "+str(hp))

func die():
	queue_free()


func _on_timer_timeout():
	is_shooting = false
