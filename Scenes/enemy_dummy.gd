extends CharacterBody3D

@onready var body = $base/body
@onready var arm = $base/body/arm
@onready var bullet = preload("res://Scenes/bullet.tscn")
@onready var barrel = $base/body/arm/gun/RayCast3D
@onready var gun = $base/body/arm/gun
@onready var timer = $base/body/arm/gun/Timer
@onready var ray_view = $base/body/head/ray_view
@onready var direction_helper = $base/body/direction_helper
@onready var head = $base/body/head



var player = null

@export var turn_speed_horizontally = 9
@export var turn_speed_vertically = 9

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	
	player = get_tree().get_nodes_in_group("player")[0]
	
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var dir_to_player = rad_to_deg(body.global_position.angle_to(player.global_position))
	
	#if(ray_view.get_collider() != player):
		#body.rotate_y(1.0*delta)
	direction_helper.look_at(player.global_transform.origin,Vector3.UP)
	body.rotate_y(-deg_to_rad(direction_helper.rotation.y * turn_speed_horizontally*delta))
	head.rotate_x(-deg_to_rad(direction_helper.rotation.x * turn_speed_vertically*delta))
	arm.rotate_x(-deg_to_rad(direction_helper.rotation.x * turn_speed_vertically*delta))
	timer.connect("timeout",_timeout)
	print(dir_to_player)
	
func _timeout():
	shoot()

func shoot():
	var new_bullet = bullet.instantiate()	
	new_bullet.position = barrel.global_position
	new_bullet.transform.basis = gun.global_transform.basis
	get_tree().root.get_children()[0].add_child(new_bullet);
