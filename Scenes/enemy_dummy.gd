extends CharacterBody3D

@onready var body = $base/body
@onready var arm = $base/body/arm
@onready var bullet = preload("res://Scenes/bullet.tscn")
@onready var barrel = $base/body/arm/gun/RayCast3D
@onready var gun = $base/body/arm/gun
@onready var timer = $base/body/arm/gun/Timer

var player = null

@export var turn_speed = 4.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	
	player = get_tree().get_nodes_in_group("player")[0]
	
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	#var dir_to_player = body.global_position.direction_to(player.global_position)
	body.rotate_y(1.0*delta)

	timer.connect("timeout",_timeout)
	print(get_tree().root.get_children()[0])
	
func _timeout():
	shoot()

func shoot():
	var new_bullet = bullet.instantiate()	
	new_bullet.position = barrel.global_position
	new_bullet.transform.basis = gun.global_transform.basis
	get_tree().root.get_children()[0].add_child(new_bullet);
