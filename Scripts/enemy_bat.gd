extends CharacterBody3D

@onready var aim_helper: Node3D = $aim_helper
@onready var view_line: RayCast3D = $MeshInstance3D/view_line
@onready var timer_wait_until_charge: Timer = $timer_wait_until_charge
@onready var explosion_area: Area3D = $MeshInstance3D/explosion_area
@onready var explosion: Node3D = $explosion


var hp = 100
var speed_fly = 10
var speed_charge = 70
var speed_turn = 5
var player = null
var player_near = false

@onready var move_direction: Vector3 = Vector3(0.0,0.0,0.0)
var rotationx = 0
var rotationy = 0
var state = 1
#0.. idle
#1..check if player visible
#2..turning towards player
#3..charging

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	
func _physics_process(delta):
	# Add the gravity.
	print(str(velocity.x)+"x "+str(velocity.y)+" y "+str(velocity.z)+"z; state: "+str(state))
	check_player_on_raycast()
	if hp <= 0:
		die()
	aim_helper.look_at(player.head.global_position)
	
	match state:
		0:
			velocity = Vector3(0.0,0.0,0.0)
			#pass
		1:
			aim()
			state = 2
		2:
			turn_towards_player()
			if check_player_on_raycast():
				timer_wait_until_charge.start()
			
		3:
			
			velocity = global_transform.basis.z.normalized() * speed_charge * delta
			#check if close to player
			if player_near == true:
				state = 4
		4:
			#explosion
			explosion._signal_explosion()
		_:
			pass
	#move_and_collide(move_direction)
	#velocity = global_transform.basis.z.normalized() * speed_charge * delta
	#velocity = move_direction
	move_and_slide()

func aim():
	rotationx = -aim_helper.rotation.x
	rotationy = aim_helper.rotation.y+deg_to_rad(180)

func turn_towards_player():
	rotation.x = rotationx
	rotation.y = rotationy
	
func die():
	queue_free()
	
func attack():
	pass

func check_player_on_raycast():
	
	if view_line.is_colliding() == true:
		if view_line.get_collider() == player:
			print("player on raycast")
			return true
	return false
	print("player not on raycast")
	
func _on_bone_head_bodypart_hit(dmg, time_rooted):
	hp -= dmg

func _on_attention_area_body_entered(body):
	pass # Replace with function body.


func _on_attention_area_body_exited(body):
	pass # Replace with function body.


func _on_timer_wait_until_charge_timeout() -> void:
	state = 3


func _on_explosion_area_body_entered(body: Node3D) -> void:
	pass # Replace with function body.


func _on_explosion_area_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
