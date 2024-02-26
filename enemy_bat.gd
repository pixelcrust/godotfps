extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.

	move_and_slide()

func die():
	pass
	
func attack():
	pass

func _on_bone_head_bodypart_hit(dmg, time_rooted):
	pass # Replace with function body.


func _on_attention_area_body_entered(body):
	pass # Replace with function body.


func _on_attention_area_body_exited(body):
	pass # Replace with function body.
