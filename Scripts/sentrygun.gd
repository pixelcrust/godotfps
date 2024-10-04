extends Node3D

@onready var gun = $gun
@onready var ray_cast_3d = $gun/barrel/RayCast3D
@onready var laser = $gun/barrel/RayCast3D/laser
@onready var bullet = preload("res://Scenes/bullets/bullet.tscn")
@onready var muzzleflash = $gun/barrel/muzzleflash/GPUParticles3D

#sound
@onready var audio_stream_player_3d = $AudioStreamPlayer3D
@onready var sound_shoot = preload("res://Sounds/gun.wav")
const sound_searching = preload("res://Sounds/Atari PC2 - Floppy Failure 3.wav")

@onready var between_shots: Timer = $between_shots
@export var time_between_bullets = 1

var horizontal_shooting_error_range = 0
var vertical_shooting_error_range = 0
var player = null


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


@onready var start_pos = transform.origin
var current_angle = 0
var going_left = true
var is_shooting = false

var on_player = false #if raycast hits player
var already_shot = false #for the cooldown between shots

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if hp <= 0:
		die()

	if ray_cast_3d.is_colliding():
		
		var victim = ray_cast_3d.get_collider()
		if  victim.is_in_group("group_player") == true:
			on_player = true
		else:
			on_player = false
			
	aim(delta)
	match state:
		0:
			pass
		1:
			pass
		2: #shoot at player
			if on_player == true:
				shoot()
			pass
	

func aim(delta):
	
	gun.rotation.x = calculate_z_angle(gun.global_position,player.head.global_position) 
	gun.rotation.y = calculate_y_angle(gun.global_position,player.head.global_position)+deg_to_rad(90)
	print(str(rad_to_deg(gun.rotation.y)))

func shoot():

	if already_shot == false:
		between_shots.wait_time = time_between_bullets
		between_shots.start() 
		muzzleflash.set_emitting(true)
		muzzleflash.restart()
		audio_stream_player_3d.stream = sound_shoot
		audio_stream_player_3d.play(0.0)
		var new_bullet = bullet.instantiate()
		new_bullet.position = ray_cast_3d.global_position #+ Vector3(0,0,-1)
		new_bullet.transform.basis = gun.global_transform.basis
		new_bullet.ads = 1
		new_bullet.rotation.y = calculate_y_angle(gun.global_position,player.head.global_position)#gun.global_position.direction_to(player.head.global_position).y#gun.rotation.y+randi_range(-horizontal_shooting_error_range,horizontal_shooting_error_range)+deg_to_rad(90)+deg_to_rad(180)
		new_bullet.rotation.z = calculate_z_angle(gun.global_position,player.head.global_position)# +deg_to_rad(180)#gun.global_position.direction_to(player.head.global_position).z#gun.rotation.z+randi_range(-vertical_shooting_error_range,vertical_shooting_error_range)
		get_tree().root.get_children()[0].add_child(new_bullet)
		already_shot = true


func calculate_z_angle(position_from,position_to):

	# Calculate the vector between the two nodes
	var direction = position_to - position_from
	var direction1 = position_to - position_from + Vector3(1,0,0)
	var direction2 = position_to - position_from + Vector3(-1,0,0)
	
	# Calculate the vertical angle (angle in the Y-axis)
	var vertical_angle = -atan2(direction.y, abs(direction.x))
	var vertical_angle1 = -atan2(direction1.z, direction1.x)
	var vertical_angle2 = -atan2(direction2.z, direction2.x)
	var vertical_angle_durchschnitt = (vertical_angle+vertical_angle1+vertical_angle2)/3
	return vertical_angle_durchschnitt
	
func calculate_y_angle(position_from,position_to):
	var direction = position_to - position_from
	var horizontal_angle = -atan2(direction.z, direction.x)
	return horizontal_angle
	
	
	
func _on_physical_bone_3d_bodypart_hit(dmg, time_rooted):
	hp -= dmg
	print("hp left: "+str(hp))

func die():
	queue_free()


func _on_timer_timeout():
	already_shot = false
