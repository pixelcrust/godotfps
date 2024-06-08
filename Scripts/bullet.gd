extends Node3D

var SPEED = 160.0
const ACCURACY = 0#5
const dmg = 50
const time_rooted = .5

@onready var mesh = $MeshInstance3D
@onready var raycast = $RayCast3D
@onready var particles = $GPUParticles3D
@onready var standard_abweichung_x = randf_range(-ACCURACY,ACCURACY)
@onready var standard_abweichung_y = randf_range(-ACCURACY,ACCURACY)
@onready var abweichung_x = 0
@onready var abweichung_y = 0
@onready var ads = 3 #0.. bullet not shot from ads 1.. bullet shot from ads
@onready var blood_splatter = $blood_splatter
var visibility_cooldown = .015
@onready var bullet_hole = preload("res://Scenes/bullet_hole.tscn")
@onready var player_shot = false
var pos_before = Vector3(0,0,0)
var victim = null
var target = Vector3(0,0,0)
var once = 0
@onready var position_bullet_before = global_position
# Called when the node enters the scene tree for the first time.
func _ready():
	
	position_bullet_before = global_position
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#set inacuracy
	if ads == 1:
		abweichung_x = 0
		abweichung_y = 0
	else:
		abweichung_x = standard_abweichung_x
		abweichung_y = standard_abweichung_y
	#print_debug("abweichung_x,abweichung_y:" +str(abweichung_x)+"/"+str(abweichung_y))
	#if Input.is_action_just_pressed("debug_bullet_move"):
	position_bullet_before = position
	position += transform.basis * Vector3(SPEED,0+abweichung_y,0+abweichung_x)*delta
	visibility_cooldown -= delta
	
	raycast.global_position = position_bullet_before
	raycast.target_position.y = -3
	
	
	if raycast.is_colliding():
		victim = raycast.get_collider()
	
	
	#raycast.force_raycast_update()
	
	#execute when target found
	if(victim != null):
		#print("raycast collision with:" + str(victim) )
		if((player_shot == true) && (victim.is_in_group("group_player") == true)):
			pass
		else:
			mesh.visible = false
			SPEED = 0
			global_position = raycast.get_collision_point()
			if victim.is_in_group("has_blood"):
				blood_splatter.on = true
			else:
				particles.emitting = true
			
				#create bullet hole
				var collision_normal = raycast.get_collision_normal()
				var new_bullet_hole = bullet_hole.instantiate()
				new_bullet_hole.global_transform.origin = raycast.get_collision_point()# - Vector3(0,0,0)
				get_tree().root.get_children()[0].add_child(new_bullet_hole)
				if collision_normal == Vector3.DOWN:
					new_bullet_hole.rotation_degrees.x = 90
				elif collision_normal == Vector3.UP:
					new_bullet_hole.rotation_degrees.x = -90
				else:
					new_bullet_hole.look_at(raycast.get_collision_point() - collision_normal, Vector3(0,1,0))
			if(victim.is_in_group("has_hp")):
				#print("hit has_hp")
				victim.hit(dmg,time_rooted)
			victim = null
			raycast.set_enabled(false)
			print("raycast disabled")
			visibility_cooldown = 2
			await get_tree().create_timer(2.0).timeout
			queue_free()
	elif visibility_cooldown <= 0:
		mesh.visible = true
	#print("pos before: "+str(position_bullet_before)+"pos_now: "+str(global_position))
	

func _on_timer_timeout():
	queue_free()
	

