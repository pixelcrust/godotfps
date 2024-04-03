extends Node3D

@onready var gun = $gun
@onready var ray_cast_3d = $gun/barrel/RayCast3D
@onready var laser = $gun/barrel/RayCast3D/laser
@onready var aim_helper = $gun/barrel/aim_helper
@onready var bullet = preload("res://Scenes/bullet.tscn")

var horizontal_shooting_error_range = 0
var vertical_shooting_error_range = 0
var player = null
var turn_speed_horizontally = 30
var direction = 0

@onready var state = 0
"""0 move left right
	1 aim directly
	2 shoot
	3 wait to move back if not again collision
	4 move back to start
	"""

@onready var time_aiming = 120
@onready var time_between_bullets = 10
@export var angle = 50
@onready var start_pos = transform.origin

# Called when the node enters the scene tree for the first time.

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var going_left = false
	var current_angle = 0

	var target = ray_cast_3d.get_collision_point()
	
	print("state: "+ str(state))
	match state:
		0:
			if going_left:
				current_angle += delta
				if current_angle >= angle:
					going_left = false
			else:
				current_angle -= delta
				if current_angle <= 0:
					going_left = true
			gun.rotate_y(current_angle)
			#if spott player
			if ray_cast_3d.is_colliding():
				if ray_cast_3d.get_collider().is_in_group("has_blood"):
					state = 1
		1:#state follow player
			#return to state 0
			aim_helper.look_at(target)
			aim(delta)
			#rotation.z = aim_helper.rotation.z
			#rotation.y = aim_helper.rotation.y
			if ray_cast_3d.is_colliding() == false:
				state = 3
			else:
				if ray_cast_3d.get_collider().is_in_group("has_blood") == false:
					state = 3
				else:
					state = 2
		2:	#shoot
			shoot()
			
			#if ray_cast_3d.get_collider().is_in_group("has_blood") == false:
			state = 3
		3: #wait until moving back
			await get_tree().create_timer(1).timeout
			if ray_cast_3d.get_collider().is_in_group("has_blood") == false:
				state = 4
			else:
				await get_tree().create_timer(3).timeout
				state = 2
		4: #move back to starting position
			transform.origin = start_pos
			gun.rotation.x = 0
			gun.rotation.y = 0
			state = 0
		_:
			pass
			
func aim(delta):
	#uses the player not the collision with raycast
	# aiming from the arm of the enemy to the head of the player
	var global_pos1 = gun.global_transform.origin
	var global_pos2 = player.head.global_transform.origin

	# Calculate the vector between the two nodes
	direction = global_pos2 - global_pos1
	
	# Calculate the vertical angle (angle in the Y-axis)
	var vertical_angle = atan2(direction.y, abs(direction.x))
	#print_debug(rad_to_deg(vertical_angle))
	gun.rotation.x = clamp(-vertical_angle,-30,30) #+ deg_to_rad(randi_range(-vertical_shooting_error_range,vertical_shooting_error_range))
	aim_helper.look_at(player.global_transform.origin,Vector3.UP)
	var ray_collider = ray_cast_3d.get_collider()
	var vertical_angle_to_player = 0
	
	if( ray_collider != player):
		rotate_y(-deg_to_rad(aim_helper.rotation.y * turn_speed_horizontally*delta))
		#arm.rotate_z(deg_to_rad(dir_to_player) * turn_speed_horizontally*delta)
		var ray_gun_collider = ray_cast_3d.get_collider()
		
	else:
		#timer.start()
		#print("raycastcollider:"+str(ray_view.get_collider())+".... player:"+str(player))
		pass
		
func shoot():
	#print("arm rotation.z: "+str(rad_to_deg(arm.rotation.z))+"body_rotation: "+str(rad_to_deg(rotation.y)))
	#await get_tree().create_timer(3).timeout
	var new_bullet = bullet.instantiate()
	new_bullet.position = aim_helper.global_position
	new_bullet.transform.basis = aim_helper.global_transform.basis
	new_bullet.rotation.y = new_bullet.rotation.y+deg_to_rad(90)+randi_range(-horizontal_shooting_error_range,horizontal_shooting_error_range)
	new_bullet.rotation.z = new_bullet.rotation.z+randi_range(-vertical_shooting_error_range,vertical_shooting_error_range)
	get_tree().root.get_children()[0].add_child(new_bullet);
