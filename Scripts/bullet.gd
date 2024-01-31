extends Node3D

const SPEED = 80.0
const ACCURACY = 2
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
@onready var blood_splatter = $blood_splatter/GPUParticles3D


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
	print_debug("ads bullet:" +str(ads))
	position += transform.basis * Vector3(SPEED,0+abweichung_y,0+abweichung_x)*delta
	if raycast.is_colliding():
		#print("raycast collision with:" + str(raycast.get_collider()) )
		mesh.visible = false
		if raycast.get_collider().is_in_group("has_blood"):
			blood_splatter.emitting = true
		else:
			particles.emitting = true
		if(raycast.get_collider().is_in_group("has_hp")):
			raycast.get_collider().hit(dmg,time_rooted)

		raycast.enabled = false
		await get_tree().create_timer(2.0).timeout
		queue_free()
	


func _on_timer_timeout():
	queue_free()
	

