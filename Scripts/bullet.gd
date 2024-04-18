extends Node3D

const SPEED = 20#60.0
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
var visibility_cooldown = 0
@onready var bullet_hole = preload("res://bullet_hole.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$AudioStreamPlayer3D.play(0.0)
	#pass  #Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#set inacuracy
	if ads == 1:
		abweichung_x = 0
		abweichung_y = 0
	else:
		abweichung_x = standard_abweichung_x
		abweichung_y = standard_abweichung_y
	#print_debug("abweichung_x,abweichung_y:" +str(abweichung_x)+"/"+str(abweichung_y))
	position += transform.basis * Vector3(SPEED,0+abweichung_y,0+abweichung_x)*delta
	visibility_cooldown -= .2
	if raycast.is_colliding():
		#print("raycast collision with:" + str(raycast.get_collider()) )
		mesh.visible = false
		if(raycast.get_collider()!= null):
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
				new_bullet_hole.look_at(raycast.get_collision_point() - collision_normal, Vector3(0,1,0))
					
				
			if(raycast.get_collider().is_in_group("has_hp")):
				print("hit has_hp")
				raycast.get_collider().hit(dmg,time_rooted)
		raycast.enabled = false
		await get_tree().create_timer(2.0).timeout
		queue_free()
	#if visibility_cooldown <= 0:
		#mesh.visible = true


func _on_timer_timeout():
	queue_free()
	

