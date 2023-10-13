extends CharacterBody3D

@onready var body = $base/body
@onready var arm = $base/body/arm
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
	
	var dir_to_player = global_position.direction_to(player.global_position)
	#body.y.angle = dir_to_player
