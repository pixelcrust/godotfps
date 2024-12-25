extends CharacterBody3D

@onready var aim_helper: Node3D = $aim_helper
@onready var bat: MeshInstance3D = $MeshInstance3D
@onready var view_line: RayCast3D = $MeshInstance3D/view_line

var hp = 100
var speed_fly = 10
var speed_charge = 70
var speed_turn = 5
var player = null

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	

	
func _physics_process(delta):
	# Add the gravity.
	aim()
	if hp <= 0:
		die()
	aim_helper.look_at(player.head.global_position)
	#move_and_slide()

func aim():
	bat.rotation.x = -aim_helper.rotation.x
	bat.rotation.y = aim_helper.rotation.y+deg_to_rad(180)
	
func die():
	queue_free()
	
func attack():
	pass

func check_player_on_raycast():
	
	if view_line.is_colliding() == true:
		if view_line.get_collider() == player:
			return true
	return false
	

func _on_bone_head_bodypart_hit(dmg, time_rooted):
	hp -= dmg
	


func _on_attention_area_body_entered(body):
	pass # Replace with function body.


func _on_attention_area_body_exited(body):
	pass # Replace with function body.
