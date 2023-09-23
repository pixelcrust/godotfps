extends CharacterBody3D

@onready var attack_raycast = $MeshInstance3D/attack_raycast
@onready var nav_agent = $NavigationAgent3D
const hp_start = 100
const SPEED = 1000
@onready var hp = hp_start


# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = 9.8
var player
@export var turn_speed = 4.0
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]


func _physics_process(delta):
	
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
	
	move_and_slide()
	#$Node3D.look_at(player.global_transform.origin,Vector3.FORWARD)
	#rotate_y(deg_to_rad($Node3D.rotation.y*turn_speed))
	#$MeshInstance3D/NavigationAgent3D.set_target_position(player.global_transform.origin)
	#var velocity = ($MeshInstance3D/NavigationAgent3D.get_next_path_position() - transform.origin).normalized() *SPEED *delta
	#move_and_collide(velocity)
	
	if(hp <= 0):
		dying()
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)

	#move_and_slide()
func dying():
	queue_free()	

func _on_physical_bone_3d_bodypart_hit(dmg):
	print("fish minus leben" +str(dmg))
	
	hp -= dmg
	print("fish hp: " +str(hp))
	
func _on_physical_bone_3d_2_bodypart_hit(dmg):
	print("fish minus leben" +str(dmg))
	
	hp -= dmg
	print("fish hp: " +str(hp))
