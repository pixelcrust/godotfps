extends CharacterBody3D

@onready var body = $base/body
@onready var arm = $base/body/arm
@onready var bullet = preload("res://Scenes/bullet.tscn")
@onready var ray_gun = $base/body/arm/gun/ray_gun
@onready var gun = $base/body/arm/gun
@onready var timer = $base/body/arm/gun/Timer
@onready var ray_view = $base/body/head/ray_view
@onready var direction_helper = $base/body/direction_helper
@onready var head = $base/body/head
const SPEED = 5
@onready var hp_start = 100
@onready var hp = hp_start
var vertical_shooting_error_range = deg_to_rad(2)
var horizontal_shooting_error_range = deg_to_rad(2)
@onready var state = -1 
#0.. idle
#1..aiming at player

var player = null

@export var turn_speed_horizontally = 30
@export var turn_speed_vertically = 79

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	
	player = get_tree().get_nodes_in_group("player")[0]
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	#print_debug("state:" + str(state))
	match state:
		0:
			#pass
			timer.stop()
			state = 2
		1: #aiming and shooting
			if timer.time_left == 0:
				timer.start()
			#print_debug(timer.time_left)
			aim(delta)
			timer.connect("timeout",_timeout)
			velocity.x = 0
			velocity.z = 0
		2: #move
			#velocity = transform.basis.z * delta * SPEED *70
			pass
		_:
			state = 0
	move_and_slide()
	
	if hp <= 0:
		die()
	
func aim(delta):
	#var dir_to_player = rad_to_deg(body.global_position.angle_to(player.global_position))
	
	# aiming from the arm of the enemy to the head of the player
	var global_pos1 = arm.global_transform.origin
	var global_pos2 = player.head.global_transform.origin

	# Calculate the vector between the two nodes
	var direction = global_pos2 - global_pos1
	
	# Calculate the vertical angle (angle in the Y-axis)
	var vertical_angle = atan2(direction.y, abs(direction.x))
	#print_debug(rad_to_deg(vertical_angle))
	arm.rotation.z = vertical_angle #+ deg_to_rad(randi_range(-vertical_shooting_error_range,vertical_shooting_error_range))
	direction_helper.look_at(player.global_transform.origin,Vector3.UP)
	var ray_collider = ray_view.get_collider()
	var vertical_angle_to_player = 0
	
	if( ray_collider != player):
		rotate_y(-deg_to_rad(direction_helper.rotation.y * turn_speed_horizontally*delta))
		#arm.rotate_z(deg_to_rad(dir_to_player) * turn_speed_horizontally*delta)
		var ray_gun_collider = ray_gun.get_collider()
		
	else:
		#timer.start()
		#print("raycastcollider:"+str(ray_view.get_collider())+".... player:"+str(player))
		pass
		
func _timeout():
	if ray_view.is_colliding():
		if ray_view.get_collider().is_in_group("group_player"):
			shoot()
	if state == 1:
		timer.start()

func shoot():
	#print("arm rotation.z: "+str(rad_to_deg(arm.rotation.z))+"body_rotation: "+str(rad_to_deg(rotation.y)))
	var new_bullet = bullet.instantiate()	
	new_bullet.position = gun.global_position
	new_bullet.transform.basis = direction_helper.global_transform.basis
	new_bullet.rotation.y = new_bullet.rotation.y+deg_to_rad(90)+randi_range(-horizontal_shooting_error_range,horizontal_shooting_error_range)
	new_bullet.rotation.z = new_bullet.rotation.z+randi_range(-vertical_shooting_error_range,vertical_shooting_error_range)
	get_tree().root.get_children()[0].add_child(new_bullet);

func _on_physical_bone_3d_bodypart_hit(dmg,time_rooted):
	hp-=dmg

func _on_attention_area_body_entered(body):
	if body.is_in_group("group_player"):
		state = 1

func _on_attention_area_body_exited(body):
	if body.is_in_group("group_player"):
		state = 0

func die():
	queue_free()
