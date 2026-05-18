extends RigidBody3D

@onready var once = 0
@onready var throwing_multiplier = 12
@onready var model_stone = $MeshInstance3D
@onready var audio_stream_player_3d = $AudioStreamPlayer3D
@onready var collision_shape_3d_2: CollisionShape3D = $Area3D/CollisionShape3D2
@onready var area_3d: Area3D = $Area3D

@onready var bullet_hole = preload("res://Scenes/effects/bullet_hole.tscn")
@export var dmg : int = 5
@export var time_rooted : float = .1

signal signal_explosion()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#model_stone.mesh.set_layer_mask_value(1,true)
	#model_stone.mesh.set_layer_mask_value(2,false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(once == 0):
		apply_impulse(transform.basis.x *throwing_multiplier)
		once = 1
	
	
func _on_timer_timeout():
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
		

	#print("stone collision with:" + str(body) )
	if(body.is_in_group("player_root") == true):
		print("stone hit player")
	#elif body.is_ancestor_of(self):
		#print("stone hit stone")
	else:
		if body.is_in_group("has_blood"):
			pass
			#blood_splatter.on = true
		else:
				#particles.emitting = true
			pass
				#create bullet hole
			"""var collision_normal = collision_shape_3d_2.get_collision_normal()
			var new_bullet_hole = bullet_hole.instantiate()
			new_bullet_hole.global_transform.origin = collision_shape_3d_2.get_collision_point()# - Vector3(0,0,0)
			get_tree().root.get_children()[0].add_child(new_bullet_hole)
			if collision_normal == Vector3.DOWN:
				new_bullet_hole.rotation_degrees.x = 90
			elif collision_normal == Vector3.UP:
				new_bullet_hole.rotation_degrees.x = -90
			else:
				new_bullet_hole.look_at(collision_shape_3d_2.get_collision_point(collision_normal, Vector3(0,1,0))) -""" 
		if(body.is_in_group("has_hp")):
			print("hit has_hp")
			body.hit(dmg,time_rooted)
			#raycast.set_enabled(false)
			#print("raycast disabled")
			#visibility_cooldown = 2
		await get_tree().create_timer(2.0).timeout
		queue_free()
