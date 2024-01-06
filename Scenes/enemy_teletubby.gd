extends CharacterBody3D

@onready var ray_view = $body/head/ray_view
@onready var direction_helper = $body/direction_helper
@onready var head = $body/head
@onready var snout = $body/head/snout
@onready var raycast_snout = $body/head/raycast_snout



@onready var vomit = preload("res://Scenes/vomit.tscn")
const SPEED = 2
@onready var hp_start = 100
@onready var hp = hp_start
@onready var state = -1 
#0.. idle
#1..aiming at player



var player = null

@export var turn_speed_horizontally = 40
@export var turn_speed_vertically = 59

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	
	player = get_tree().get_nodes_in_group("player")[0]
	
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	direction_helper.look_at(player.global_transform.origin,Vector3.UP)
	
	print_debug("state:" + str(state))
	match state:
		0:	#patrol
			velocity.x = 0
			velocity.z = 0
		1: #rotate and walk towards if seeing
			#print_debug(timer.time_left)
			rotate_y(-deg_to_rad(direction_helper.rotation.y * turn_speed_horizontally*delta))
			aim(delta)
			velocity = transform.basis.z * delta * SPEED *70
		2: #shoot
			shoot()
			velocity.x = 0
			velocity.z = 0
		_:
			state = 0
	move_and_slide()
	#print_debug(hp)
	if hp <= 0:
		die()
	
func aim(delta):
	#var dir_to_player = rad_to_deg(body.global_position.angle_to(player.global_position))
	
	
	# aiming from the arm of the enemy to the head of the player
	var global_pos1 = global_transform.origin
	var global_pos2 = player.head.global_transform.origin

	# Calculate the vector between the two nodes
	var direction = abs(global_pos2 - global_pos1)
	



func shoot():
	var new_vomit = vomit.instantiate()
	new_vomit.position = snout.global_position + Vector3(0,0,.5)
	new_vomit.transform.basis = snout.global_transform.basis
	get_tree().root.get_children()[0].add_child(new_vomit);

func _on_physical_bone_3d_bodypart_hit(dmg,time_rooted):
	hp-=dmg
	



func die():
	#print_debug("ded")
	queue_free()

func _on_attention_area_body_entered(body):
	if body.is_in_group("group_player"):
		if state != 2:
			state = 1
	

func _on_attention_area_body_exited(body):
	if body.is_in_group("group_player"):
		state = 0

func _on_attention_area_small_body_entered(body):
	if body.is_in_group("group_player"):
		state = 2 # Replace with function body.



func _on_attention_area_small_body_exited(body):
	if body.is_in_group("group_player"):
		if state != 2:
			state = 1 # Replace with function body.
