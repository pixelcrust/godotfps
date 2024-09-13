extends CharacterBody3D

const SPEED = 7.0
const ACCURACY = .2
const dmg = 1
const time_rooted = .01

@onready var mesh = $MeshInstance3D
@onready var raycast = $RayCast3D

@onready var particles = $GPUParticles3D
@onready var standard_abweichung_x = randf_range(-ACCURACY,ACCURACY)
@onready var standard_abweichung_y = randf_range(-ACCURACY,ACCURACY)
@onready var abweichung_x = 0
@onready var abweichung_y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#$AudioStreamPlayer3D.play(0.0)
	pass  #Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#set inacuracy
	abweichung_x = standard_abweichung_x
	abweichung_y = standard_abweichung_y
		
	position += transform.basis * Vector3(0+abweichung_y,0+abweichung_x,SPEED)*delta
	if raycast.is_colliding():
		#print("raycast collision with:" + str(raycast.get_collider()) )
		mesh.visible = false
		#particles.emitting = true
		var collider = raycast.get_collider()
		if(collider.is_in_group("has_hp")):
			collider.hit(dmg,time_rooted)
			print_debug("collider: "+str(collider))
		raycast.enabled = false
		queue_free()


func _on_timer_timeout():
	queue_free()
	
