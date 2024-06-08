extends Node3D

const SPEED = 320.0
const ACCURACY = 0#6
const dmg = 100
const time_rooted = 1

@onready var mesh = $MeshInstance3D
@onready var raycast = $RayCast3D
@onready var particles = $GPUParticles3D
@onready var standard_abweichung_x = randf_range(-ACCURACY,ACCURACY)
@onready var standard_abweichung_y = randf_range(-ACCURACY,ACCURACY)
@onready var abweichung_x = 0
@onready var abweichung_y = 0
@onready var ads = 3 #0.. bullet not shot from ads 1.. bullet shot from ads
@onready var blood_splatter = $blood_splatter
var bullet_hole = preload("res://Scenes/bullet_hole.tscn")
@onready var player_shot = false
@onready var position_bullet_before = global_position
# Called when the node enters the scene tree for the first time.
func _ready():
	#set inacuracy
	position_bullet_before = global_position
	#print_debug("ads bullet: "+str(ads))
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if ads == 1:
		abweichung_x = 0
		abweichung_y = 0
	else:
		abweichung_x = standard_abweichung_x
		abweichung_y = standard_abweichung_y
	position_bullet_before = position
	position += transform.basis * Vector3(SPEED,0+abweichung_y,0+abweichung_x)*delta
	
	raycast.global_position = position_bullet_before
	raycast.target_position.y = -6
	#print_debug("ads bullet: "+str(ads))
	if raycast.is_colliding():
		#print("raycast collision with:" + str(raycast.get_collider()) )
		if((player_shot == true) && (raycast.get_collider().is_in_group("group_player") == true)):
			pass
		else:
			mesh.visible = false
			if raycast.get_collider().is_in_group("has_blood"):
				blood_splatter.on = true
			else:
				particles.emitting = true
				#create bullet hole
				var collision_normal = raycast.get_collision_normal()
				var new_bullet_hole = bullet_hole.instantiate()
				new_bullet_hole.global_transform.origin = raycast.get_collision_point()#- Vector3(-1,-1,0)
				#raycast.get_collider().add_child(new_bullet_hole)
				get_tree().root.get_children()[0].add_child(new_bullet_hole)
				#if collision_normal == Vector3.DOWN:
				#new_bullet_hole.rotation_degrees.x = 90
				#elif collision_normal != Vector3.UP:				
				if collision_normal == Vector3.DOWN:
					new_bullet_hole.rotation_degrees.x = 90
				elif collision_normal == Vector3.UP:
					new_bullet_hole.rotation_degrees.x = -90
				else:
					new_bullet_hole.look_at(raycast.get_collision_point() - collision_normal, Vector3(0,1,0))
			if(raycast.get_collider().is_in_group("has_hp")):
				raycast.get_collider().hit(dmg,time_rooted)
			raycast.enabled = false
			await get_tree().create_timer(1.0).timeout
			queue_free()


func _on_timer_timeout():
	queue_free()
